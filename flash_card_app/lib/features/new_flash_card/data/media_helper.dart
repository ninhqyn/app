import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class MediaHelper {
  final Map<String, String> _uniqueFiles = {};

  final _mediaStreamController = StreamController<File>.broadcast();
  Stream<File> get mediaStream => _mediaStreamController.stream;

  /// Kiểm tra file có phải là video không
  Future<bool> isVideo(File file) async {
    try {
      final bytes = await file.openRead(0, 12).first;
      String hexString = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

      if (hexString.contains('66747970') || // MP4, MOV signature
          hexString.contains('52494646') || // AVI signature
          hexString.contains('1a45dfa3')) { // MKV signature
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi khi kiểm tra định dạng file: $e');
      return false;
    }
  }

  /// Kiểm tra file có phải là ảnh không
  Future<bool> _isImage(File file) async {
    try {
      final bytes = await file.openRead(0, 12).first;
      String hexString = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

      if (hexString.startsWith('ffd8ff') || // JPEG
          hexString.startsWith('89504e47') || // PNG
          hexString.startsWith('474946')) { // GIF
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi khi kiểm tra định dạng ảnh: $e');
      return false;
    }
  }

  /// Lấy tất cả file ảnh và video
  Future<List<File>> getAllMediaFiles() async {
    final List<File> mediaFiles = [];
    final files = await getAllFilesByExtension(
        ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi', 'mkv']
    );

    for (var file in files) {
      if (await _isMediaFile(file)) {
        mediaFiles.add(file);
        _mediaStreamController.add(file);
      }
    }
    return mediaFiles;
  }

  /// Kiểm tra xem file có phải là media không
  Future<bool> _isMediaFile(File file) async {
    final extension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      return await _isImage(file);
    }

    if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
      return await isVideo(file);
    }

    return false;
  }

  /// Lấy tất cả file ảnh
  Future<List<File>> getAllImageFiles() async {
    final List<File> imageFiles = [];
    final files = await getAllFilesByExtension(['jpg', 'jpeg', 'png', 'gif']);

    for (var file in files) {
      if (await _isImage(file)) {
        imageFiles.add(file);
        _mediaStreamController.add(file);
      }
    }
    return imageFiles;
  }

  /// Lấy tất cả file video
  Future<List<File>> getAllVideoFiles() async {
    final List<File> videoFiles = [];
    final files = await getAllFilesByExtension(['mp4', 'mov', 'avi', 'mkv']);

    for (var file in files) {
      if (await isVideo(file)) {
        videoFiles.add(file);
        _mediaStreamController.add(file);
      }
    }
    return videoFiles;
  }

  // Các phương thức khác giữ nguyên như cũ...

  void dispose() {
    _mediaStreamController.close();
  }
  /// Yêu cầu quyền truy cập bộ nhớ
  Future<bool> requestPermission() async {
    try {
      // Đối với Android 13+, sử dụng manageExternalStorage
      PermissionStatus status;
      if (Platform.isAndroid) {
        status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
      } else {
        // Đối với iOS hoặc các nền tảng khác, dùng quyền storage (nếu cần)
        status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return status.isGranted;
    } catch (e) {
      print('Lỗi khi yêu cầu quyền truy cập: $e');
      return false;
    }
  }

  /// Lấy tất cả file ảnh và video
  Future<List<File>> getAllImageAndVideoFiles() async {
    return getAllFilesByExtension(['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi', 'mkv']);
  }

  /// Lấy tất cả các file từ bộ nhớ theo phần mở rộng (extension)
  Future<List<File>> getAllFilesByExtension(List<String> extensions) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        return [];
      }

      // Xóa dữ liệu cũ để đảm bảo chúng ta có một danh sách mới
      _uniqueFiles.clear();

      // Lấy thư mục gốc của bộ nhớ ngoài (external storage)
      final Directory? externalDir = Directory('/storage/emulated/0'); // Android
      if (externalDir == null || !externalDir.existsSync()) {
        print('Không thể truy cập bộ nhớ ngoài');
        return [];
      }

      // Duyệt qua tất cả các file trong bộ nhớ
      await _scanDirectory(externalDir, extensions);

      // Chuyển đổi các đường dẫn duy nhất thành đối tượng File
      final List<File> files = _uniqueFiles.values.map((path) => File(path)).toList();

      print('Tìm thấy ${files.length} file không trùng lặp');
      return files;
    } catch (e) {
      print('Lỗi khi lấy danh sách file: $e');
      return [];
    }
  }

  /// Tạo chữ ký cho file dựa trên kích thước và thời gian sửa đổi
  String _createFileSignature(File file) {
    try {
      final stat = file.statSync();
      final size = stat.size;
      final modified = stat.modified.millisecondsSinceEpoch;
      final signature = '$size-$modified';
      return sha256.convert(utf8.encode(signature)).toString();
    } catch (e) {
      // Fallback nếu không thể tạo chữ ký
      return file.path;
    }
  }

  /// Hàm đệ quy để quét thư mục
  Future<void> _scanDirectory(Directory dir, List<String> extensions) async {
    try {
      final entities = dir.listSync(recursive: false);
      for (var entity in entities) {
        if (entity is File) {
          // Kiểm tra phần mở rộng của file
          final extension = entity.path.split('.').last.toLowerCase();
          if (extensions.contains(extension)) {
            // Tạo chữ ký cho file để xác định tính duy nhất
            final signature = _createFileSignature(entity);

            // Chỉ thêm file nếu chưa có trong danh sách
            if (!_uniqueFiles.containsKey(signature)) {
              _uniqueFiles[signature] = entity.path;
            }
          }
        } else if (entity is Directory) {
          // Bỏ qua các thư mục hệ thống hoặc không truy cập được
          if (!_isSystemFolder(entity.path)) {
            try {
              await _scanDirectory(entity, extensions);
            } catch (e) {
              print('Lỗi khi quét thư mục ${entity.path}: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Lỗi trong thư mục ${dir.path}: $e');
    }
  }

  /// Kiểm tra xem thư mục có phải là thư mục hệ thống không
  bool _isSystemFolder(String path) {
    final systemFolders = [
      '/storage/emulated/0/Android',
      '/storage/emulated/0/system',
      '/storage/emulated/0/data',
      // Thêm các thư mục khác nếu cần
    ];
    return systemFolders.any((folder) => path.startsWith(folder));
  }

  /// Lấy tất cả file audio
  Future<List<File>> getAllAudioFiles() async {
    return getAllFilesByExtension( ['mp3', 'wav', 'aac', 'flac', 'm4a']);
  }
}