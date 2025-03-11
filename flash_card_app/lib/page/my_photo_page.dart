import 'dart:io';

import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/features/new_flash_card/data/media_helper.dart';
import 'package:flash_card_app/features/video_play/bloc/video_play_bloc.dart';
import 'package:flash_card_app/widget/my_app_bar.dart';
import 'package:flash_card_app/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPhotos extends StatefulWidget {
  const MyPhotos({super.key, required this.isFont});
  final bool isFont;
  @override
  State<MyPhotos> createState() => _MyPhotosState();
}

class _MyPhotosState extends State<MyPhotos> {
  List<File> file = [];
  int photoSelected = 0;
  final MediaHelper mediaHelper = MediaHelper();

  @override
  void initState(){
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if(widget.isFont){
      final files = await mediaHelper.getAllImageFiles();
      if (mounted) {
        setState(() {
          file = files;
        });
      }
    }else{
      final files = await mediaHelper.getAllImageAndVideoFiles();
      if (mounted) {
        setState(() {
          file = files;
        });
      }
    }
  }

  bool _isVideo(String path) {
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];
    final extension = path.split('.').last.toLowerCase();
    return videoExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    double paddingHorizontal = 20.0;

    return  SafeArea(
        child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: MyAppBar(title: 'Photos')),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: widget.isFont ? listPhoto(context): listPhotoAndImage(context)
                ),
              ),
            )
        )

);

  }
  Widget listPhoto(BuildContext context){
    double mainSpace = 10.0;
    int count = 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: mainSpace,
        mainAxisSpacing: mainSpace,
      ),
      itemCount: file.length,
      itemBuilder: (context, index) {
        final image = file[index];
        return Container(
          decoration: photoSelected==index ? BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: Colors.black,
                  width: 2
              )
          ):BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: (){
                setState(() {
                  photoSelected = index;
                });
                context.read<NewFlashCardBloc>().add(QuestionImageChanged(questionImage: image.path));
                Navigator.pop(context);
              },
              child:  Image.file(
                File(image.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.video_file,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  Widget listPhotoAndImage(BuildContext context){
    double mainSpace = 10.0;
    int count = 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: mainSpace,
        mainAxisSpacing: mainSpace,
      ),
      itemCount: file.length,
      itemBuilder: (context, index) {
        final image = file[index];
        bool isVideo = _isVideo(image.path);
        return Container(
          decoration: photoSelected==index ? BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: Colors.black,
                  width: 2
              )
          ):BoxDecoration(
            borderRadius: BorderRadius.circular(15),

          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: (){
                setState(() {
                  photoSelected = index;
                });
                context.read<NewFlashCardBloc>().add(AnswerImageChanged(image.path));
                if(_isVideo(image.path)){
                  context.read<VideoPlayBloc>().add(LoadVideo(image.path));
                }
                Navigator.pop(context);
              },
              child: !isVideo ?  Image.file(
                File(image.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.video_file,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ): VideoCard(videoFile: image,isPlay: false,),
            )
  ,
),

        );
      },
    );
  }
}
