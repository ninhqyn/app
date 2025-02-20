
import 'dart:io';
import 'package:app_audio/data/sqlite.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import '../widget/loading.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller = VideoPlayerController.networkUrl(
      Uri.parse(""));
  Future<void> _initializeVideoPlayerFuture = Future.value();
  String videoDuration = '00:00'; // Total video duration
  String currentDuration = '00:00'; // Current playback time
  String videoPath = "";
  FileDatabase db = FileDatabase.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguemnts = ModalRoute
          .of(context)!
          .settings
          .arguments as Map;
      if (arguemnts['page'] == 'choose-video') {
        final File video = arguemnts['asset'];
        _initializeVideoPlayer(video);
      } else {
        final url = arguemnts['path'];
        print(arguemnts['path']);
        _initializeVideoPlayer2(url);
      }
    });
  }

  Future<void> _initializeVideoPlayer2(String url) async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await _controller.initialize();
    _initializeVideoPlayerFuture = _controller
        .initialize(); // Gán giá trị cho _initializeVideoPlayerFuture
    // Set video loop
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    // Add listener to update current duration
    _controller.addListener(_updateCurrentDuration);
    videoPath = url;
    // Get total video duration after initialization
    await _initializeVideoPlayerFuture; // Wait for initialization to complete
    setState(() {
      videoDuration = _formatDuration(_controller.value.duration);
    });
  }

  Future<void> _initializeVideoPlayer(File file) async {
    if (file != null) {
      _controller = VideoPlayerController.file(file);
      _initializeVideoPlayerFuture = _controller
          .initialize(); // Gán giá trị cho _initializeVideoPlayerFuture
      // Set video loop
      _controller.setLooping(true);
      _controller.setVolume(1.0);
      // Add listener to update current duration
      _controller.addListener(_updateCurrentDuration);
      videoPath = file.path;
      // Get total video duration after initialization
      await _initializeVideoPlayerFuture; // Wait for initialization to complete
      setState(() {
        videoDuration = _formatDuration(_controller.value.duration);
      });
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
        directory = Directory('/storage/emulated/0/DCIM/Camera');
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
  void saveFileVideo()  async{
    String? path = await saveVideo(videoPath);
    if(path == null){
      print('can t save file');

    }else{
      File file = File(path);
       await db.saveFileInfo(name: 'video 1', path: path, size: file.lengthSync(), type: FileDatabase.TYPE_VIDEO);
       print('success video');
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
  void dispose() {
    _controller.removeListener(
        _updateCurrentDuration); // Remove listener on dispose
    _controller.dispose();
    super.dispose();
  }

  // Update current duration every second
  void _updateCurrentDuration() {
    if (_controller.value.isInitialized && _controller.value.isPlaying) {
      setState(() {
        currentDuration = _formatDuration(_controller.value.position);
      });
    }
  }

  // Format duration to HH:MM:SS or MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Go back
                },
              ),
              const Text(
                'Play video',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              Container()
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _controller.value.isInitialized ? FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        // Chiều rộng cắt của video (80% của video gốc)
                        heightFactor: 0.5,
                        // Chiều cao cắt của video (50% của video gốc)
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ) : const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    // Linear progress indicator
                    LinearProgressIndicator(
                      value: _controller.value.isInitialized
                          ? _controller.value.position.inMilliseconds /
                          _controller.value.duration.inMilliseconds
                          : 0.0,
                    ),
                    const SizedBox(height: 10),
                    // Row showing the current and total time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentDuration,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          videoDuration,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Nút lùi 10 giây
                          InkWell(
                            onTap: () {
                              // Lùi 10 giây
                              final currentPosition = _controller.value
                                  .position;
                              final newPosition = currentPosition -
                                  const Duration(seconds: 10);
                              _controller.seekTo(newPosition.isNegative
                                  ? Duration.zero
                                  : newPosition);
                            },
                            child: SvgPicture.asset('assets/images/back10.svg'),
                          ),
                          // Nút phát/pause
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                            child: SvgPicture.asset(
                              _controller.value.isPlaying
                                  ? 'assets/images/play.svg'
                                  : 'assets/images/pause.svg',
                            ),
                          ),
                          // Nút tua 10 giây
                          InkWell(
                            onTap: () {
                              // Tua 10 giây
                              final currentPosition = _controller.value
                                  .position;
                              final newPosition = currentPosition +
                                  const Duration(seconds: 10);
                              _controller.seekTo(newPosition);
                            },
                            child: SvgPicture.asset('assets/images/next10.svg'),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const CustomLoadingWidget(); // Hiển thị loading khi xuất audio
                        },
                      );

                      String? path = await convertMp4ToMp32(videoPath);
                      if(path == null){
                        return;
                      }
                      Navigator.pop(context); // Đóng loading dialog
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.popAndPushNamed(
                            context, '/export-successful', arguments: path);
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      minimumSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width / 2, 48),
                    ),
                    child: const Text("Export audio",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {

                      saveFileVideo();

                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      minimumSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width / 2, 48),
                    ),
                    child: const Text("Save video",
                        style: TextStyle(fontSize: 16, color: Colors.black)
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      minimumSize: Size(
                          MediaQuery
                              .of(context)
                              .size
                              .width / 2, 48),
                    ),
                    child: const Text("Share",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
