import 'dart:io';
import 'package:flash_card_app/features/new_flash_card/data/video_info.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatefulWidget {
  final File videoFile;
  final double width;
  final double height;
  final bool isPlay;
  const VideoCard({
    super.key,
    required this.videoFile,
    this.width = double.infinity,
    this.height = double.infinity,
    required this.isPlay
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {

  late VideoInfo videoInfo;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    print('Khởi tạo VideoCard với file: ${widget.videoFile.path}');
    _initializeVideoInfo();
  }

  Future<void> _initializeVideoInfo() async {
    try {
      if (!widget.videoFile.existsSync()) {
        print('ERROR: File video không tồn tại: ${widget.videoFile.path}');
        _handleError('File không tồn tại');
        return;
      }

      videoInfo = VideoInfo(widget.videoFile);
      await videoInfo.initialize();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Lỗi trong _initializeVideoInfo: $e');
      print('Stack trace: $stackTrace');
      _handleError('$e');
    }
  }

  void _handleError(String errorMessage) {
    if (mounted) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (hasError || videoInfo.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 32),
            const SizedBox(height: 8),
            Text(
              'Không thể tải video',
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Thumbnail
        if (videoInfo.thumbnailPath != null)
          Image.file(
            File(videoInfo.thumbnailPath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              print('Lỗi khi hiển thị thumbnail: $error');
              return _buildPlaceholder();
            },
          )
        else
          _buildPlaceholder(),

        // Play button overla

        // Duration overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
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
            child: Row(
               mainAxisAlignment: !widget.isPlay ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if(widget.isPlay) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                // Duration
                Text(
                  videoInfo.formattedDuration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )

                // Filename if needed
                /* Text(
                  widget.videoFile.path.split('/').last,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ), */
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.video_file,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}