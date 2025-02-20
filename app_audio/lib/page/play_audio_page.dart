import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayPage extends StatefulWidget {
  //static const routeName = '/play-audio';

  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late AudioPlayer _audioPlayer;
  Duration? _duration;
  Duration? _position;
  bool _isPlaying = false;
  late String audioPath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy arguments từ route
    final args = ModalRoute.of(context)!.settings.arguments as String;
    audioPath = args;
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(audioPath)),
      );

      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _duration = duration;
        });
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });

      _audioPlayer.playerStateStream.listen((state) {
        setState(() {
          _isPlaying = state.playing;
        });
      });
    } catch (e) {
      debugPrint("Error initializing audio player: $e");
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "0:00";
    String minutes = duration.inMinutes.toString();
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Dừng phát audio
    _audioPlayer.dispose(); // Giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width/2.5;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Play audio',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                ),
              ),
              Container()
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 50),
            SizedBox(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: width,
                  height: width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: SvgPicture.asset(
                            'assets/images/head_phone.svg',
                            height: width/2,
                            width: width/2,
                          )
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: _position != null && _duration != null
                        ? _position!.inMilliseconds / _duration!.inMilliseconds
                        : 0.0,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position)),
                      Text(_formatDuration(_duration)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              _audioPlayer.seek(
                                  _position != null
                                      ? _position! - const Duration(seconds: 10)
                                      : Duration.zero
                              );
                            },
                            child: SvgPicture.asset('assets/images/back10.svg')
                        ),
                        InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              setState(() {
                                if (_isPlaying) {
                                  _audioPlayer.pause();
                                } else {
                                  _audioPlayer.play();
                                }
                              });
                            },
                            child: SvgPicture.asset(
                                _isPlaying
                                    ? 'assets/images/play.svg'
                                    : 'assets/images/pause.svg'
                            )
                        ),
                        InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              _audioPlayer.seek(
                                  _position != null
                                      ? _position! + const Duration(seconds: 10)
                                      : Duration.zero
                              );
                            },
                            child: SvgPicture.asset('assets/images/next10.svg')
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-ringtone',arguments: audioPath);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                minimumSize: Size(
                    MediaQuery.of(context).size.width / 2,
                    48
                ),
              ),
              child: const Text(
                  "Create ringtone",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}