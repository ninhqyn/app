

import 'package:flutter/material.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/sql/sqlite_helper.dart';
import 'package:note_app/widget/bottom_sheet.dart';
import 'package:note_app/widget/list_note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Note App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String textValue ="";
  List<Note> items = [];
  _loadNote() async{
    var item = await _dbHelper.getNotes();
    setState(() {
      items.clear();
      items.addAll(item);
    });
  }
   _handleAddData(Note note) async{
     await _dbHelper.addNote(note);
     _loadNote();  // Tải lại danh sách
    
  }
  _handleDeleteData(int id) async{
    await _dbHelper.deleteNote(id);
    _loadNote();
  }
  _handleEditData(Note note) async{
    await _dbHelper.updateNote(note);
    _loadNote();
  }
  
  @override
  void initState() {
    super.initState();
    _loadNote();  // Tải dữ liệu khi ứng dụng bắt đầu
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              )
            ]),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body:   Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child:  TabBarView(
              children: [
                ListNote(items,_handleDeleteData,_handleEditData),
                const Center(child: Text('Content of Tab 2')),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context){
                      return BottomSheetContent(onNoteAdded: _handleAddData);
                    });
              }
                ,child: const Icon(Icons.add,size: 40)
            ,),
        ),
      ),
    );
  }
}
