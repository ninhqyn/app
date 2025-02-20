import 'dart:io';
import 'dart:typed_data';

import 'package:app_audio/data/sqlite.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

import '../widget/loading.dart';
class ExportPage extends StatefulWidget{
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final TextEditingController controller = TextEditingController();

  final db = FileDatabase.instance;

  Future<Uint8List> convertFileToBlob (String filepath) async{
    File file = File(filepath);
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }
  void saveFileInformation(String sourcePath) async {
    String? path = await saveAudio(sourcePath);
    File file = File(sourcePath);
    await db.saveFileInfo(name: controller.text, path: path!, size: file.lengthSync(),type: FileDatabase.TYPE_AUDIO);
    print('Success save to sqlite');
  }

  Future<String?> saveAudio(String sourcePath) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'AUDIO_$timestamp.m4a'; // Đổi thành định dạng audio

      // Xác định thư mục lưu trữ
      Directory? directory;
      if (Platform.isAndroid) {
        // Thử lấy thư mục Music
        directory = Directory('/storage/emulated/0/Music');
        if (!await directory.exists()) {
          // Tạo thư mục nếu chưa tồn tại
          await directory.create(recursive: true);
        }
      } else {
        // Cho iOS hoặc các platform khác
        directory = await getApplicationDocumentsDirectory();
      }

      final outputPath = '${directory.path}/$fileName';

      // Sử dụng FFmpeg để convert và lưu audio
      final arguments = [
        '-i', sourcePath,
        '-vn',  // Bỏ qua video stream
        '-acodec', 'aac',  // Sử dụng AAC codec cho audio
        '-b:a', '192k',    // Bitrate cho audio
        outputPath
      ];

      final session = await FFmpegKit.executeWithArguments(arguments);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        // Thông báo thành công
        if (context.mounted) {
          print('Đã lưu audio vào ${directory.path}');
        }
        return outputPath;
      } else {
        // Thông báo lỗi
        if (context.mounted) {
          print('Không thể lưu audio');
        }
        return null;
      }
    } catch (e) {
      print('Lỗi khi lưu audio: $e');
      if (context.mounted) {
        print('Có lỗi xảy ra khi lưu audio');
      }
      return null;
    }
  }


  @override
    Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width/2.5;
      String path = ModalRoute.of(context)!.settings.arguments as String;
      return SafeArea(
        child: Scaffold(
          appBar:PreferredSize(
            preferredSize: const Size.fromHeight(60),  // Kích thước của AppBar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Quay lại màn hình trước
                  },
                ),
                const Text(
                  'Export successful',
                  style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w700),
                ),
                Container()
              ],
            ),
          ),
          // Use a FutureBuilder to display a loading spinner while waiting for the
          // VideoPlayerController to finish initializing.
          body: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width,
                      height: width,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1E9E9), // Màu xám cho hình chữ nhật
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: FittedBox(
                            fit: BoxFit.cover,
                              child: SvgPicture.asset('assets/images/head_phone.svg',height: width/2,width: width/2,))
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/play-audio',arguments: path);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black), // Đặt border của nút
                        minimumSize: Size(MediaQuery.of(context).size.width/2, 48), // Đảm bảo chiều rộng bằng màn hình và chiều cao là 50
                      ),
                      child: const Text("Play now", style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    // Các nút còn lại với style giống như nút đầu tiên
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/create-ringtone');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        minimumSize: Size(MediaQuery.of(context).size.width/2, 48),
                      ),
                      child: const Text("Create ringtone", style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                       showModalBottomSheet(
                           context: context,
                           builder: (context){
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
                                               labelText: "Name audio"
                                           ),
                                         ),
                                         const SizedBox(height: 10,),
                                         SizedBox(
                                             width: double.infinity,
                                             height: 50,
                                             child: ElevatedButton(onPressed: ()async {
                                               saveFileInformation(path);

                                               if (context.mounted) {
                                                 Navigator.pop(context); // Đóng loading dialog
                                               }
                                             },style: ElevatedButton.styleFrom(
                                                 backgroundColor: Colors.blue,
                                                 shape: RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.circular(10)
                                                 )
                                             ),
                                                 child: const Text("Save",style: TextStyle(color: Colors.white),)))
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
                        minimumSize: Size(MediaQuery.of(context).size.width / 2, 48),
                      ),
                      child: const Text("Save audio",
                          style: TextStyle(fontSize: 16, color: Colors.black)
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
              const Spacer()


            ],
          ),
        ),
      );
  }
}