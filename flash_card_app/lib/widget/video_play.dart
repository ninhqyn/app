import 'dart:async';
import 'dart:io';
import 'package:flash_card_app/features/new_flash_card/data/video_info.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  final File videoFile;
  final double width;
  final double height;
  const VideoPlay({
    Key? key,
    required this.videoFile,
    this.width = double.infinity,
    this.height = double.infinity,
  }): super(key: key);

  @override
  VideoPlayState createState() => VideoPlayState();
}

class VideoPlayState extends State<VideoPlay>{
  late VideoPlayerController controller;
  Future<void> _initializeVideoPlayerFuture = Future.value();
  late VideoInfo videoInfo;
  bool isLoading = true;
  bool hasError = false;
  bool isPlaying = false;
  late Timer _timer;
  String _currentPosition = '0:00';

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
    _initializeVideoInfo();
    _initializeVideoPlayer();

  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted && controller.value.isInitialized) {
        _updateVideoTime();
      }
    });
  }
  void _updateVideoTime() {
    final Duration position = controller.value.position;
    setState(() {
      _currentPosition = _formatDuration(position);
    });
  }
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  Future<void> _initializeVideoPlayer() async {
    controller = VideoPlayerController.file(widget.videoFile);
    _initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
    controller.setVolume(5.0);
    await _initializeVideoPlayerFuture;

    // Khởi tạo timer sau khi controller đã initialize
    if (mounted) {
      _startTimer();
    }
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

  void _togglePlayback() {
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
        isPlaying = false; // Thêm dòng này
      } else {
        isPlaying = true;
        controller.play();
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    controller.dispose();
    super.dispose();
  }
  void cleanupVideo() {
    if (mounted) {
      controller.pause();
      _timer.cancel();
    }
  }
  @override
  void didUpdateWidget(VideoPlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoFile.path != oldWidget.videoFile.path) {
      _timer.cancel();
      controller.dispose();
      setState(() {
        isLoading = true;
        isPlaying = false;
        _currentPosition = '0:00';
      });
      _initializeVideoInfo();
      _initializeVideoPlayer();
      _startTimer();
    }
  }
  Widget _buildControls() {
    return Container(
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
        children: [
          InkWell(
            onTap: _togglePlayback,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Hiển thị thời gian hiện tại / tổng thời gian
          Text(
            '$_currentPosition / ${videoInfo.formattedDuration}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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
        // Hiển thị thumbnail nếu chưa phát video
        if (!isPlaying)
          videoInfo.thumbnailPath != null
              ? Image.file(
            File(videoInfo.thumbnailPath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              print('Lỗi khi hiển thị thumbnail: $error');
              return _buildPlaceholder();
            },
          )
              : _buildPlaceholder(),

        // Hiển thị video nếu đang phát
        if (isPlaying && controller.value.isInitialized)
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        // Controls luôn hiển thị
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildControls()
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


}