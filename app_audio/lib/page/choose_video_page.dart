import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

import '../widget/video_card.dart';

class ChooseVideo extends StatefulWidget {
  const ChooseVideo({super.key});

  @override
  State<ChooseVideo> createState() => _ChooseVideoState();
}

class _ChooseVideoState extends State<ChooseVideo> {

  List<AssetEntity> _videos = [];
  List<FileSystemEntity> videoFiles = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Đặt code sử dụng context ở đây
      final arguemnts = ModalRoute.of(context)!.settings.arguments as Map;;
      if(arguemnts['page'] == 'device'){
        _loadVideos();
      }else{
        _getAllVideoFiles();
      }
    });


  }

  Future<void> _loadVideos() async {
    List<AssetEntity> videos = await getAllVideo();
    setState(() {
      _videos = videos;
    });
  }

  Future<List<AssetEntity>> getAllVideo() async {
    // Lấy tất cả album
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
    );
    // Lấy tất cả video từ tất cả album
    Set<AssetEntity> allVideo = {}; // Dùng Set để loại bỏ video trùng lặp

    for (var album in albums) {
      List<AssetEntity> videos = await album.getAssetListRange(
        start: 0,
        end: await album.assetCountAsync,
      );
      // Thêm tất cả video vào Set để loại bỏ video trùng lặp
      allVideo.addAll(videos);
    }

    // Chuyển lại Set thành List để dễ xử lý
    return allVideo.toList();
  }


  Future<void> _getAllVideoFiles() async {
    try {
      List<File> videoFilesList = [];

      // 2. Lấy đường dẫn thư mục gốc
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print('Không thể truy cập bộ nhớ ngoài');
        return;
      }

      // 3. Đường dẫn tới thư mục gốc Android
      String androidRootPath = externalDir.path.split('Android')[0];

      // 4. Hàm quét thư mục
      Future<void> scanDirectory(String directoryPath) async {
        try {
          Directory directory = Directory(directoryPath);
          if (await directory.exists()) {
            List<FileSystemEntity> entities = await directory.list().toList();

            for (var entity in entities) {
              if (entity is File) {
                String path = entity.path.toLowerCase();
                if (path.endsWith('.mp4')) {
                  videoFilesList.add(File(entity.path));
                  print('Tìm thấy video: ${entity.path}');
                }
              } else if (entity is Directory) {
                // Bỏ qua một số thư mục hệ thống
                if (!entity.path.contains('/Android/data') &&
                    !entity.path.contains('/Android/obb') &&
                    !entity.path.contains('/.') &&
                    !entity.path.contains('/Android/media')) {
                  await scanDirectory(entity.path);
                }
              }
            }
          }
        } catch (e) {
          print('Lỗi khi quét thư mục ${directoryPath}: $e');
        }
      }

      // 5. Bắt đầu quét từ thư mục gốc
      await scanDirectory(androidRootPath);

      // 6. Thêm các thư mục phổ biến chứa video
      List<String> commonVideoPaths = [
        '/storage/emulated/0/DCIM',
        '/storage/emulated/0/Movies',
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Pictures',
      ];

      for (String path in commonVideoPaths) {
        await scanDirectory(path);
      }

      // 7. Cập nhật state
      setState(() {
        videoFiles = videoFilesList;
        print('Tổng số video tìm thấy: ${videoFiles.length}');
      });

    } catch (e) {
      print('Lỗi khi quét video: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Choose Video',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: arguments['page'] != 'device'
          ? _buildLocalVideoGrid()
          : _buildAssetVideoGrid(),
    );
  }

// Widget hiển thị video từ local
  Widget _buildLocalVideoGrid() {
    if (videoFiles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: videoFiles.length,
      itemBuilder: (context, index) {
        final video = videoFiles[index];
        return InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  '/play-video',
                  arguments: {
                    'page': 'choose-video',
                    'asset': video
                  }
              );
            },
            child: VideoCard(videoFile: File(video.path))
        );
      },
    );
  }

// Widget hiển thị video từ AssetEntity
  Widget _buildAssetVideoGrid() {
    if (_videos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final AssetEntity video = _videos[index];
        // Sử dụng FutureBuilder để xử lý việc chuyển đổi AssetEntity thành File
        return FutureBuilder<File?>(
          future: video.file,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Icon(Icons.error),
              );
            }

            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context,
                    '/play-video',
                    arguments: {
                      'page': 'choose-video',
                      'asset': snapshot.data
                    }
                );
              },
              child: VideoCard(videoFile: snapshot.data!),
            );
          },
        );
      },
    );
  }

}
