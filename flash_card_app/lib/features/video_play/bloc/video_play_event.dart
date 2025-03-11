part of 'video_play_bloc.dart';

@immutable
abstract class VideoPlayEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVideo extends VideoPlayEvent {
  final String videoUrl;

  LoadVideo(this.videoUrl);

  @override
  List<Object> get props => [videoUrl];
}

class PlayVideo extends VideoPlayEvent {}

class PauseVideo extends VideoPlayEvent {}
class CancelVideo extends VideoPlayEvent {}
class SeekTo extends VideoPlayEvent {
  final Duration position;

  SeekTo(this.position);

  @override
  List<Object> get props => [position];
}

class SetVolume extends VideoPlayEvent {
  final double volume;

  SetVolume(this.volume);

  @override
  List<Object> get props => [volume];
}

class ToggleFullScreen extends VideoPlayEvent {}
