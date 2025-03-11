import 'package:flash_card_app/features/video_play/bloc/video_play_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class MyVideoPlay extends StatefulWidget {
  const MyVideoPlay({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<MyVideoPlay> createState() => _MyVideoPlayState();
}

class _MyVideoPlayState extends State<MyVideoPlay> {
  @override
  void initState() {
    super.initState();
    // Tải video khi widget được khởi tạo
  }

  @override
  void dispose() {
    // Hủy video khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayBloc, VideoPlayState>(
      builder: (context, state) {
        // Xử lý trạng thái đang tải
        if (state is VideoLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Xử lý trạng thái lỗi
        if (state is VideoError) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VideoPlayBloc>().add(LoadVideo(widget.videoUrl));
                    },
                    child: const Text("Thử lại"),
                  ),
                ],
              ),
            ),
          );
        }

        // Xử lý các trạng thái video đã tải
        VideoPlayerController? controller;
        if (state is VideoLoaded) {
          controller = state.controller;
        } else if (state is VideoPlaying) {
          controller = state.controller;
        } else if (state is VideoPaused) {
          controller = state.controller;
        } else if (state is VolumeChanged) {
          controller = state.controller;
        } else if (state is FullScreenToggled) {
          controller = state.controller;
        }

        if (controller == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayer(controller),
                // Lớp điều khiển
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
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Phát hoặc tạm dừng video
                              if (controller!.value.isPlaying) {
                                context.read<VideoPlayBloc>().add(PauseVideo());
                              } else {
                                context.read<VideoPlayBloc>().add(PlayVideo());
                              }
                            },
                            icon: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        // Thêm các điều khiển video khác nếu cần
                        Expanded(
                          child: VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.red,
                              bufferedColor: Colors.white54,
                              backgroundColor: Colors.white24,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}