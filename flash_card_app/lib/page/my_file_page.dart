import 'dart:io';

import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/widget/card_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/new_flash_card/data/media_helper.dart';
import '../widget/my_app_bar.dart';

class MyFile extends StatefulWidget {
  const MyFile({super.key});

  @override
  State<MyFile> createState() => _MyFileState();
}

class _MyFileState extends State<MyFile> {
  List<File> file = [];
  final MediaHelper mediaHelper = MediaHelper();
  int selected = -1;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    final files = await mediaHelper.getAllAudioFiles();
    if (mounted) {
      setState(() {
        file = files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: MyAppBar(title: 'File',
                urlAction: 'assets/images/check.svg', routeName: '/preview',),
            ),
            Expanded(
              child: BlocBuilder<NewFlashCardBloc, NewFlashCardState>(
                builder: (context, state) {
                  if(state is NewFlashCardInitial){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: file.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            setState(() {
                              selected = index;
                              context.read<NewFlashCardBloc>().add(AnswerAudioChanged(file[index].path));
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10
                            ),
                            child: selected == index ? CardFile(file: file[index],isSelected: true,):
                           CardFile(file: file[index],isSelected: false,)
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
