part of 'video_play_bloc.dart';

@immutable
abstract class VideoPlayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoPlayState {}

class VideoLoading extends VideoPlayState {}

class VideoLoaded extends VideoPlayState {
  final VideoPlayerController controller;

  VideoLoaded(this.controller);

  @override
  List<Object?> get props => [controller];
}

class VideoPlaying extends VideoPlayState {
  final VideoPlayerController controller;

  VideoPlaying(this.controller);

  @override
  List<Object?> get props => [controller];
}

class VideoPaused extends VideoPlayState {
  final VideoPlayerController controller;

  VideoPaused(this.controller);

  @override
  List<Object?> get props => [controller];
}

class VolumeChanged extends VideoPlayState {
  final VideoPlayerController controller;
  final double volume;

  VolumeChanged(this.controller, this.volume);

  @override
  List<Object?> get props => [controller, volume];
}

class FullScreenToggled extends VideoPlayState {
  final VideoPlayerController controller;

  FullScreenToggled(this.controller);

  @override
  List<Object?> get props => [controller];
}

class VideoError extends VideoPlayState {
  final String message;

  VideoError(this.message);

  @override
  List<Object?> get props => [message];
}