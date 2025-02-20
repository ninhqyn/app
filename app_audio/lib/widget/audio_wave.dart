import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWaveformPainter extends CustomPainter{
  final List<double> waveformData;
  final double progress; //0.0-> 1.0
  AudioWaveformPainter({
    required this.waveformData,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;
    final width = size.width;
    final height = size.height;
    final barWidth = width/waveformData.length;
    for (var i = 0; i < waveformData.length; i++) {
      final x = i * barWidth;
      final barHeight = waveformData[i] * height;

      // Vẽ thanh màu xám cho phần chưa phát
      paint.color = i / waveformData.length > progress
          ? Colors.grey.withOpacity(0.5)
          : Colors.black;

      canvas.drawLine(
        Offset(x, height / 2 - barHeight / 2),
        Offset(x, height / 2 + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}