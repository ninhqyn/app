import 'dart:io';
import 'package:flutter/material.dart';

import '../helper/video_infor.dart';


class VideoCard extends StatefulWidget {
  final File videoFile;

  const VideoCard({super.key, required this.videoFile});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoInfo videoInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    videoInfo = VideoInfo(widget.videoFile);
    _loadVideoInfo();
  }

  Future<void> _loadVideoInfo() async {
    try {
      await videoInfo.initialize(); // Sử dụng phương thức initialize mới

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Lỗi khi tải thông tin video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: Text('.....'),
    )
        : Stack(
      fit: StackFit.expand, // Đảm bảo stack lấp đầy card
      children: [
        // Thumbnail
        if (videoInfo.thumbnailPath != null)
          Image.file(
            File(videoInfo.thumbnailPath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.video_file,
                  color: Colors.grey,
                  size: 40,
                ),
              );
            },
          )
        else
          Container(
            color: Colors.grey[300],
            child: const Icon(
              Icons.video_file,
              color: Colors.grey,
              size: 40,
            ),
          ),

        // Duration overlay
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Text(
              videoInfo.formattedDuration,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Error indicator nếu có lỗi
        if (videoInfo.error != null)
          Positioned(
            top: 8,
            right: 8,
            child: Tooltip(
              message: videoInfo.error!,
              child: const Icon(
                Icons.error,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    // Cleanup nếu cần
    super.dispose();
  }
}
