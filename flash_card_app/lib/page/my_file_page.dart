import 'package:flash_card_app/widget/card_file.dart';
import 'package:flutter/material.dart';

class MyFile extends StatefulWidget {
  const MyFile({super.key});

  @override
  State<MyFile> createState() => _MyFileState();
}

class _MyFileState extends State<MyFile> {
  int selectedIndex = -1;
  List<String> title =[
    'Meow meow',
    'Bark Bark',
    'Quack quack',
    'Turtle'
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('File'),
        ),
        body: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: title.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child:  Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10
                  ),
                  child: index == selectedIndex ?  CardFile(title: title[index],true):CardFile(title: title[index],false)
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
