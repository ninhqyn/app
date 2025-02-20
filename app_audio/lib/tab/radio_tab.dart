

import 'dart:io';

import 'package:app_audio/data/sqlite.dart';
import 'package:flutter/material.dart';
import '../model/file_model.dart';
import '../widget/card_item.dart';
import '../widget/no_item_body.dart';

class TabRadio extends StatefulWidget{

  const TabRadio({super.key});

  @override
  State<TabRadio> createState() => _TabRadioState();
}

class _TabRadioState extends State<TabRadio> {
  bool _isEmpty = false;
  List<FileModel> files = [];
  FileDatabase db = FileDatabase.instance;
  Future<void> loadFiles() async {
    final List<Map<String, dynamic>> maps = await db.getFilesByType(FileDatabase.TYPE_AUDIO);
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
        child: NoItem(title: 'No audio',)
    )
        : Expanded(
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50)
            ),
            onTap: () async{
              Navigator.pushNamed(context, '/play-audio',arguments: files[index].path);
            },
              child: CardItem(item:files[index]));
        },
      ),
    );
  }
}