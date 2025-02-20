import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoInfo {
  final File file;
  String? thumbnailPath;
  Duration? duration;
  String? error;

  VideoInfo(this.file) {
    if (!file.existsSync()) {
      print('ERROR: File không tồn tại: ${file.path}');
    }
  }

  Future<void> initialize() async {
    try {
      await Future.wait([
        generateThumbnail(),
        getDuration(),
      ], eagerError: true);
    } catch (e) {
      print('Lỗi khởi tạo: $e');
      rethrow;
    }
  }

  Future<void> generateThumbnail() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final command = '-y -i "${file.path}" -vframes 1 -an -s 200x200 -ss 0.1 "${outputPath}"';
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        thumbnailPath = outputPath;
      } else {
        error = 'Lỗi tạo thumbnail';
      }
    } catch (e) {
      error = 'Lỗi tạo thumbnail: $e';
    }
  }

  Future<void> getDuration() async {
    try {
      // Thử dùng VideoPlayer
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      duration = controller.value.duration;
      await controller.dispose();

      if (duration != null) return;

      // Nếu không được thì dùng FFprobe
      final session = await FFprobeKit.execute(
          '-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${file.path}"'
      );

      final output = await session.getOutput();
      if (output != null && output.isNotEmpty) {
        final seconds = double.tryParse(output.trim());
        if (seconds != null) {
          duration = Duration(milliseconds: (seconds * 1000).round());
        }
      }
    } catch (e) {
      print('Lỗi get duration: $e');
    }
  }

  String get formattedDuration {
    if (duration == null) return '--:--';

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

