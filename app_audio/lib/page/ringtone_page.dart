import 'dart:io';

import 'package:app_audio/data/sqlite.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../widget/audio_wave.dart';

class RingTonePage extends StatefulWidget {
  const RingTonePage({super.key});

  @override
  State<RingTonePage> createState() => _RingTonePageState();
}

class _RingTonePageState extends State<RingTonePage> {
  late AudioPlayer _audioPlayer;
  Duration? _duration;
  Duration? _position;
  bool _isPlaying = false;
  late String audioPath;
  Duration _startPosition = Duration.zero;
  Duration _endPosition = Duration.zero;
  double _progress = 0.0;
  TextEditingController controller = TextEditingController();
  FileDatabase db = FileDatabase.instance;

  void saveRingTone() async{
    String? path = await saveVideo(audioPath);
    if(path == null){
      print('error');
    }else{
      File file = File(path);
      await db.saveFileInfo(name: controller.text, path: path, size: file.lengthSync(), type: FileDatabase.TYPE_RINGTONE);
      print('save success');
    }

  }
  Future<String?> saveVideo(String sourcePath) async {
    try {

      // Tạo tên file duy nhất với timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'VIDEO_$timestamp.mp4';

      // Xác định thư mục lưu trữ
      Directory? directory;
      if (Platform.isAndroid) {
        // Thử lấy thư mục DCIM trước
        directory = Directory('/storage/emulated/0/Ringtones');
        if (!await directory.exists()) {
          // Nếu không có DCIM, thử Movies
          directory = Directory('/storage/emulated/0/Movies');
          if (!await directory.exists()) {
            // Tạo thư mục nếu chưa tồn tại
            await directory.create(recursive: true);
          }
        }
      } else {
        // Cho iOS hoặc các platform khác
        directory = await getApplicationDocumentsDirectory();
      }

      final outputPath = '${directory.path}/$fileName';

      // Copy file sử dụng FFmpeg để đảm bảo tương thích
      final arguments = [
        '-i', sourcePath,
        '-c', 'copy',  // copy without re-encoding
        outputPath
      ];

      final session = await FFmpegKit.executeWithArguments(arguments);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        // Thông báo thành công
        if (context.mounted) {
          print('success');
        }
        return outputPath;
      } else {
        // Thông báo lỗi
        if (context.mounted) {
          print('error');
        }
        return null;
      }
    } catch (e) {
      print('Lỗi khi lưu video: $e');
      if (context.mounted) {
        print('error in save');
      }
      return null;
    }
  }

  // Hàm kiểm tra audio stream
  Future<bool> hasAudioStream(String inputPath) async {
    final session = await FFprobeKit.execute('-i "$inputPath" -show_streams -select_streams a -loglevel error');
    final output = await session.getOutput();
    return output != null && output.isNotEmpty;
  }
  Future<String?> convertMp4ToMp32(String videoPath) async {
    try {
      // Kiểm tra audio stream trước
      if (!await hasAudioStream(videoPath)) {
        print('Video không có audio stream');
        return null;
      }

      Directory tempDir = await getTemporaryDirectory();
      String outputPath = '${tempDir.path}/output_${DateTime
          .now()
          .millisecondsSinceEpoch}.m4a';
      print('Input video path: $videoPath');
      print('Output path: $outputPath');
      final arguments = [
        '-y',
        '-i', videoPath,
        '-vn', // Bỏ video
        '-acodec', 'aac', // Dùng AAC thay vì libmp3lame
        '-b:a', '192k', // Bitrate
        outputPath
      ];

      print('FFmpeg command: ffmpeg ${arguments.join(' ')}');

      FFmpegSession session = await FFmpegKit.executeWithArguments(arguments);
      final returnCode = await session.getReturnCode();

      final logs = await session.getLogs();
      print('-------- FFmpeg Logs Start --------');
      for (var log in logs) {
        print(log.getMessage());
      }
      print('-------- FFmpeg Logs End --------');

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        print('Conversion failed with return code: ${returnCode?.getValue()}');
        return null;
      }
    } catch (e, stack) {
      print('Error during conversion: $e');
      print('Stack trace: $stack');
      return null;
    }
  }
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          _endPosition = duration ?? Duration.zero;
        });
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
          if (_duration != null) {
            _progress = position.inMilliseconds / _duration!.inMilliseconds;
          }
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

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Bỏ dòng seek này đi
      // await _audioPlayer.seek(_startPosition);
      await _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }


  void _seekTo(double percent) {
    if (_duration != null) {
      final position = _duration! * percent;
      _audioPlayer.seek(position);
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
    _audioPlayer.stop();
    _audioPlayer.dispose();
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
                'Create ringtone',
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
            Container(
              width: double.infinity,
              height: width,
              decoration: const BoxDecoration(
                color: Color(0xFFE1E9E9),
              ),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final position = details.localPosition;
                  final percent = position.dx / box.size.width;
                  setState(() {
                    _progress = percent.clamp(0.0, 1.0);
                  });
                  _seekTo(_progress);
                },
                child: CustomPaint(
                  painter: AudioWaveformPainter(
                    waveformData: List.generate(100, (index) => 0.5 + 0.5 * (index % 2)),
                    progress: _progress,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_startPosition)),
                  Text(_formatDuration(_position)),
                  Text(_formatDuration(_endPosition)),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: _playPause,
                child: _isPlaying
                    ? SvgPicture.asset('assets/images/play.svg')
                    : SvgPicture.asset('assets/images/pause.svg'),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Fade in'),
                _buildActionButton('Fade out'),
              ],
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context){
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: SingleChildScrollView(
                      child:  Container(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                          child: Column(
                            children: [
                              TextField(
                                // onChanged: (text){
                                //   textValue = text;
                                // },
                                controller: controller,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Name"
                                ),
                              ),
                              const SizedBox(height: 10,),
                              SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(onPressed: (){
                                    saveRingTone();
                                    Navigator.pop(context);
                                  },style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      )
                                  ),
                                      child: const Text("Add Ringtone",style: TextStyle(color: Colors.white),)))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                minimumSize: Size(MediaQuery.of(context).size.width / 3, 48),
              ),
              child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.black)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return OutlinedButton(
        onPressed: () async {
          if (text == 'Fade in') {
            // Bắt đầu với âm lượng 0 và tăng dần lên 1
            await _audioPlayer.setVolume(0);
            for (double i = 0; i <= 1; i += 0.1) {
              await _audioPlayer.setVolume(i);
              await Future.delayed(const Duration(milliseconds: 100));
            }
          } else if (text == 'Fade out') {
            // Bắt đầu với âm lượng 1 và giảm dần về 0
            await _audioPlayer.setVolume(1);
            for (double i = 1; i >= 0; i -= 0.1) {
              await _audioPlayer.setVolume(i);
              await Future.delayed(const Duration(milliseconds: 100));
            }
          }
        },
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)
            ),
            side: const BorderSide(
                width: 1,
                color: Colors.black
            ),
            minimumSize: const Size(171, 50)
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/images/ring_tone.svg'),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.black)),
          ],
        )
    );
  }

}


