import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;

class CardFile extends StatefulWidget {
  final File file;
  final bool isSelected;
  const CardFile({super.key, required this.file, required this.isSelected});

  @override
  State<CardFile> createState() => _CardFileState();
}

class _CardFileState extends State<CardFile> {
  bool isPlaying = false;
  late AudioPlayer audioPlayer;
  String fileName = '';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    fileName = path.basename(widget.file.path);
    _initAudioPlayer();
  }

  @override
  void didUpdateWidget(CardFile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Khi widget được chọn, tự động phát
    if (widget.isSelected && !oldWidget.isSelected) {
      _playAudio();
    }
    // Khi widget không còn được chọn, dừng phát nhạc
    else if (!widget.isSelected && isPlaying) {
      audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      await audioPlayer.setFilePath(widget.file.path);
      audioPlayer.setVolume(20);
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

  Future<void> _playAudio() async {
    try {
      await audioPlayer.seek(Duration.zero);
      await audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _togglePlayPause() async {
    if (!widget.isSelected) return;

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
    return Container(
      height: 60,
      decoration: widget.isSelected
          ? BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFC9FA85),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(offset: Offset(2, 2), blurRadius: 2)
          ])
          : BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFC9FA85)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/music.svg'),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      fileName,
                      style: const TextStyle(fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: _togglePlayPause,
              child: isPlaying
                  ? SvgPicture.asset('assets/images/play.svg')
                  : SvgPicture.asset('assets/images/pause.svg'),
            ),
          ],
        ),
      ),
    );
  }
}

