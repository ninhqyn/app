import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';
import 'package:equatable/equatable.dart';
part 'video_play_event.dart';
part 'video_play_state.dart';

class VideoPlayBloc extends Bloc<VideoPlayEvent, VideoPlayState> {
  VideoPlayerController? _controller;

  VideoPlayBloc() : super(VideoInitial()) {
    on<LoadVideo>(_onLoadVideo);
    on<PlayVideo>(_onPlayVideo);
    on<PauseVideo>(_onPauseVideo);
    on<SeekTo>(_onSeekTo);
    on<SetVolume>(_onSetVolume);
    on<ToggleFullScreen>(_onToggleFullScreen);
    on<CancelVideo>(_onCancelVideo);
  }

  Future<void> _onLoadVideo(LoadVideo event, Emitter<VideoPlayState> emit) async {
    emit(VideoLoading());

    try {
      // Kiểm tra xem tệp có tồn tại không trước khi cố gắng phát
      final file = File(event.videoUrl);
      final exists = await file.exists();

      if (!exists) {
        emit(VideoError("Tệp video không tồn tại"));
        return;
      }

      // Xử lý controller hiện tại nếu có
      await _controller?.dispose();

      // Tạo controller mới với xử lý lỗi
      _controller = VideoPlayerController.file(file);

      try {
        await _controller!.initialize();
        emit(VideoLoaded(_controller!));
      } catch (e) {
        emit(VideoError("Không thể khởi tạo video: ${e.toString()}"));
        await _controller?.dispose();
        _controller = null;
      }
    } catch (e) {
      emit(VideoError("Lỗi khi tải video: ${e.toString()}"));
    }
  }

  void _onPlayVideo(PlayVideo event, Emitter<VideoPlayState> emit) {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.play();
      emit(VideoPlaying(_controller!));
    }
  }

  void _onPauseVideo(PauseVideo event, Emitter<VideoPlayState> emit) {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.pause();
      emit(VideoPaused(_controller!));
    }
  }

  void _onCancelVideo(CancelVideo event, Emitter<VideoPlayState> emit) async {
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
      _controller = null;
    }
    emit(VideoInitial());
  }

  void _onSeekTo(SeekTo event, Emitter<VideoPlayState> emit) {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.seekTo(event.position);
      if (_controller!.value.isPlaying) {
        emit(VideoPlaying(_controller!));
      } else {
        emit(VideoPaused(_controller!));
      }
    }
  }

  void _onSetVolume(SetVolume event, Emitter<VideoPlayState> emit) {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.setVolume(event.volume);
      if (_controller!.value.isPlaying) {
        emit(VolumeChanged(_controller!, event.volume));
      }
    }
  }

  void _onToggleFullScreen(ToggleFullScreen event, Emitter<VideoPlayState> emit) {
    // Logic để chuyển đổi chế độ toàn màn hình
    if (_controller != null && _controller!.value.isInitialized) {
      emit(FullScreenToggled(_controller!));
    }
  }

  @override
  Future<void> close() async {
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
      _controller = null;
    }
    return super.close();
  }
}