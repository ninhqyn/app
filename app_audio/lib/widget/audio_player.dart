import 'dart:math';

import 'package:flutter/material.dart';

import 'audio_wave.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final Function(Duration)? onPositionChanged;

  const AudioPlayerWidget({
    Key? key,
    required this.audioPath,
    this.onPositionChanged,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}


class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = details.localPosition;
        final percent = position.dx / box.size.width;
        setState(() {
          progress = percent.clamp(0.0, 1.0);
        });
      },
      child: Container(
        height: 100,
        child: CustomPaint(
          painter: AudioWaveformPainter(
            waveformData: generateDummyWaveform(), // Dữ liệu sóng âm
            progress: progress,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  List<double> generateDummyWaveform() {
    // Tạo dữ liệu mẫu
    return List.generate(100, (index) => Random().nextDouble());
  }
}
