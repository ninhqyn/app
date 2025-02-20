
import 'package:app_audio/widget/card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../data/sqlite.dart';
import '../model/file_model.dart';
import '../widget/no_item_body.dart';

class RingtoneTab extends StatefulWidget{
  const RingtoneTab({super.key});

  @override
  State<RingtoneTab> createState() => _RingtoneTabState();
}

class _RingtoneTabState extends State<RingtoneTab> {
  bool _isEmpty = false;
  List<FileModel> files = [];
  FileDatabase db = FileDatabase.instance;
  Future<void> loadFiles() async {
    final List<Map<String, dynamic>> maps = await db.getFilesByType(FileDatabase.TYPE_RINGTONE);
    setState(() {
      files = List.generate(maps.length, (i) {
        return FileModel.fromMap(maps[i]);
      });
      _isEmpty = files.isEmpty; // Cập nhật trạng thái empty
    });
  }

  @override
  void initState() {
    super.initState();
    loadFiles(); // Load dữ liệu khi widget khởi tạo
  }
  @override
  Widget build(BuildContext context) {
    return  _isEmpty == true
        ? const Expanded(
        child: NoItem(title: 'No Ringtone',)
    )
        : Expanded(
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/play-video',arguments: {
                  'page':'steam',
                  'path': files[index].path
                });
              },
              child: CardItem(item: files[index]));
        },
      ),
    );
  }
}