import 'dart:typed_data';
import 'dart:io';
import 'package:note_app/model/note.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class BottomSheetContent extends StatefulWidget {
  final Function(Note) onNoteAdded; // Callback khi thêm ghi chú

  const BottomSheetContent({super.key, required this.onNoteAdded});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  XFile? image;
  String textValue = "";
  final ImagePicker _picker = ImagePicker();

  Future _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }
  // Hàm chuyển đổi hình ảnh thành mảng byte
  Future<Uint8List> imageToBytes(XFile imageFile) async {
    final image = await imageFile.readAsBytes();
    return image;
  }

  Future<XFile> bytesToImage(Uint8List byteArray) async {
    final tempDir = await getTemporaryDirectory(); // Lấy thư mục tạm thời
    final timestamp = DateTime
        .now()
        .millisecondsSinceEpoch; // Lấy thời gian hiện tại (millisecond)
    final tempPath = join(tempDir.path,
        'image_$timestamp.png'); // Tạo tên tệp với thời gian hiện tại
    final file = File(tempPath); // Tạo đối tượng file với đường dẫn này

    // Ghi dữ liệu byte vào tệp
    await file.writeAsBytes(byteArray);

    // Trả về XFile để có thể sử dụng trong các thao tác khác
    return XFile(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.record_voice_over),
                    const SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text('Pick image'),
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _pickImage(); // Chọn ảnh từ thư viện
                                    Navigator.pop(context); // Đóng dialog
                                  },
                                  child: const Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Icon(Icons.photo_camera_back_outlined),
                                      SizedBox(width: 20),
                                      Text('Photos'),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context); // Đóng dialog
                                    },
                                    child: const Row(
                                      children: [
                                        SizedBox(width: 20),
                                        Icon(Icons.camera),
                                        SizedBox(width: 20),
                                        Text('Camera'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    textValue = text;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Your Note",
                  ),
                ),
                const SizedBox(height: 10),
                // Hiển thị ảnh nếu có
                image != null ? SizedBox(
                    child: Stack(children:[
                        Image.file(File(image!.path),height: 200,),
                        Positioned(
                          right: 0,top: 0,
                            child: InkWell(
                              onTap: (){},
                                child: Container(
                                     decoration: const BoxDecoration(
                                       color: Colors.grey,
                                       shape: BoxShape.rectangle,
                                       borderRadius:  BorderRadius.all(Radius.circular(5)),
                                     ),
                                    child: const  Padding(
                                      padding:  EdgeInsets.all(5),
                                      child:  Icon(Icons.cancel,color: Colors.black,),
                                    )
                                )
                            )
                        )
                    ] )) : const SizedBox(height: 1),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (image != null) {
                        final imageBytes = await imageToBytes(image!);
                        Note note = Note(1, textValue, imageBytes);
                        widget.onNoteAdded(note); // Thêm ghi chú
                        Navigator.pop(context); // Đóng BottomSheet
                      } else {
                        //Nếu không có ảnh, chỉ tạo note với text
                        Note note = Note(1, textValue, Uint8List(0));
                        widget.onNoteAdded(note);
                        Navigator.pop(context); // Đóng BottomSheet
                      }
                    },
                    child: const Text(
                      "Add note",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
