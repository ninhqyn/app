import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoInfo {
  final File file;
  String? thumbnailPath;
  Duration? duration;
  String? error;
  bool isInitialized = false;
  bool isActuallyVideo = true; // Xác định file có thực sự là video hay không

  VideoInfo(this.file) {
    print('VideoInfo được tạo với đường dẫn file: ${file.path}');
    // Kiểm tra file có tồn tại
    if (!file.existsSync()) {
      print('ERROR: File không tồn tại tại đường dẫn: ${file.path}');
      error = 'File không tồn tại';
    }
  }

  Future<void> initialize() async {
    if (isInitialized) {
      print('VideoInfo đã được khởi tạo trước đó, bỏ qua.');
      return;
    }

    if (error != null) {
      print('VideoInfo đã có lỗi, bỏ qua khởi tạo: $error');
      return;
    }

    try {
      print('Bắt đầu khởi tạo VideoInfo cho file: ${file.path}');

      // Trước tiên, kiểm tra xem file có phải là video thực sự không
      final hasVideoStream = await checkHasVideoStream();
      if (!hasVideoStream) {
        print('File này không chứa video stream: ${file.path}');
        isActuallyVideo = false;
        error = 'File này là audio, không phải video';
        isInitialized = true; // Đánh dấu đã khởi tạo để không thử lại
        return;
      }

      // Nếu là video thực sự, tiếp tục các tác vụ song song
      final results = await Future.wait([
        generateThumbnail(),
        getDuration(),
      ], eagerError: false); // Đặt eagerError thành false để tránh lỗi một phần dừng toàn bộ quá trình

      isInitialized = true;
      print('Khởi tạo VideoInfo thành công');
    } catch (e, stackTrace) {
      error = 'Lỗi khởi tạo: $e';
      print('Lỗi trong initialize(): $e');
      print('Stack trace: $stackTrace');
      isInitialized = false;
    }
  }

  Future<bool> checkHasVideoStream() async {
    try {
      print('Kiểm tra xem file có stream video không: ${file.path}');
      // Sử dụng FFprobe để kiểm tra stream video
      final ffprobeCommand = '-v error -select_streams v:0 -show_entries stream=codec_type -of default=noprint_wrappers=1:nokey=1 "${file.path}"';

      final session = await FFprobeKit.execute(ffprobeCommand);
      final output = await session.getOutput();
      final returnCode = await session.getReturnCode();

      print('FFprobe stream check output: $output');

      if (returnCode != null && ReturnCode.isSuccess(returnCode) &&
          output != null && output.trim().isNotEmpty &&
          output.trim().toLowerCase().contains('video')) {
        print('File này có chứa video stream');
        return true;
      }

      print('File không chứa video stream hoặc không thể xác định');
      return false;
    } catch (e) {
      print('Lỗi khi kiểm tra video stream: $e');
      return false;
    }
  }

  Future<void> generateThumbnail() async {
    try {
      if (!isActuallyVideo) {
        print('Bỏ qua tạo thumbnail vì file không phải là video');
        return;
      }

      print('Bắt đầu tạo thumbnail cho file: ${file.path}');
      final tempDir = await getTemporaryDirectory();
      // Tạo tên file dựa trên path của video để tránh tạo nhiều thumbnails cho cùng một video
      final videoPathHash = file.path.hashCode.toString();
      final outputPath = '${tempDir.path}/thumb_$videoPathHash.jpg';

      // Kiểm tra xem thumbnail đã tồn tại chưa
      final thumbFile = File(outputPath);
      if (await thumbFile.exists()) {
        print('Thumbnail đã tồn tại, sử dụng lại: $outputPath');
        thumbnailPath = outputPath;
        return;
      }

      print('Tạo thumbnail mới tại: $outputPath');

      // Tạo command sử dụng -ss trước -i để tăng tốc độ
      final command = '-y -ss 0.5 -i "${file.path}" -vframes 1 -an -s 400x300 -f image2 "${outputPath}"';
      print('FFmpeg command: $command');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        thumbnailPath = outputPath;
        print('Thumbnail được tạo thành công tại: $outputPath');

        // Kiểm tra kích thước của thumbnail
        if (await thumbFile.exists()) {
          final size = await thumbFile.length();
          print('File thumbnail tồn tại với kích thước: $size bytes');
          if (size == 0) {
            error = 'Thumbnail có kích thước 0 bytes';
            print('ERROR: Thumbnail có kích thước 0 bytes');
          }
        } else {
          error = 'Không thể tạo thumbnail';
          print('ERROR: File thumbnail không tồn tại sau khi tạo');
        }
      } else {
        error = 'Lỗi tạo thumbnail';
        print('FFmpeg return code: ${returnCode?.getValue()}');
      }
    } catch (e, stackTrace) {
      error = 'Lỗi tạo thumbnail: $e';
      print('Exception trong generateThumbnail(): $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> getDuration() async {
    try {
      print('Bắt đầu lấy duration cho file: ${file.path}');

      // Thử phương pháp 1: FFprobe (thường nhanh và hiệu quả hơn)
      print('Thử phương pháp 1: Sử dụng FFprobe...');
      final ffprobeCommand = '-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${file.path}"';

      final session = await FFprobeKit.execute(ffprobeCommand);
      final output = await session.getOutput();
      final returnCode = await session.getReturnCode();

      if (returnCode != null && ReturnCode.isSuccess(returnCode) && output != null && output.isNotEmpty) {
        try {
          final seconds = double.parse(output.trim());
          duration = Duration(milliseconds: (seconds * 1000).round());
          print('Duration từ FFprobe: $duration');
          return;
        } catch (e) {
          print('Không thể parse output từ FFprobe: $output');
          // Tiếp tục với phương pháp khác
        }
      }

      // Phương pháp 2: VideoPlayer (chỉ thử nếu file thực sự là video)
      if (isActuallyVideo) {
        print('Thử phương pháp 2: Sử dụng VideoPlayer...');
        final controller = VideoPlayerController.file(file);
        try {
          await controller.initialize().timeout(const Duration(seconds: 5));
          duration = controller.value.duration;
          print('Duration từ VideoPlayer: $duration');
        } catch (e) {
          print('Lỗi khi khởi tạo VideoPlayer: $e');
          throw e; // Ném ngoại lệ để báo lỗi
        } finally {
          await controller.dispose();
        }
      } else {
        // Nếu là audio, chỉ dựa vào kết quả từ ffprobe
        print('File là audio, chỉ sử dụng duration từ FFprobe');
      }

    } catch (e, stackTrace) {
      error = 'Lỗi lấy duration: $e';
      print('Exception trong getDuration(): $e');
      print('Stack trace: $stackTrace');
    }
  }

  String get formattedDuration {
    if (duration == null) {
      return '--:--';
    }

    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds % 60;

    if (minutes >= 60) {
      final hours = duration!.inHours;
      final mins = minutes % 60;
      return '$hours:${mins.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}