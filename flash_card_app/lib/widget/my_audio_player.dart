import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key, required this.audioPath});
  final String audioPath;

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  // Thay đổi cách khai báo - khởi tạo ngay khi khai báo thay vì sử dụng late
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await audioPlayer.setFilePath(widget.audioPath);
      audioPlayer.setVolume(20);

      // Đánh dấu đã khởi tạo thành công
      setState(() {
        isInitialized = true;
      });

      audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state.playing;
          });

          if (state.processingState == ProcessingState.completed) {
            setState(() {
              isPlaying = false;
            });
          }
        }
      });
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  void _togglePlayPause() async {
    // Kiểm tra đã khởi tạo chưa trước khi thực hiện
    if (!isInitialized) {
      print('Audio player not initialized yet');
      return;
    }

    try {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.seek(Duration.zero);
        await audioPlayer.play();
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: Colors.black
              ),
              shape: BoxShape.circle,
              color: const Color(0xFFC9FA85),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 1,
                    color: Colors.black
                ),
              ]
          ),
          child: Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: !isPlaying
                  ? SvgPicture.asset('assets/images/pause.svg')
                  : SvgPicture.asset('assets/images/play.svg'),
            ),
          ),
        ),
        const SizedBox(width: 20,),
        Text(path.basenameWithoutExtension(widget.audioPath), style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20
        ),)
      ],
    );
  }
}