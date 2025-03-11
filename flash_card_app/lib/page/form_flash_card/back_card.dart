import 'dart:io';

import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/features/video_play/bloc/video_play_bloc.dart';
import 'package:flash_card_app/widget/card_title.dart';
import 'package:flash_card_app/widget/my_video_play.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../widget/my_audio_player.dart';
class BackCard extends StatefulWidget{
  const BackCard({super.key});
  @override
  State<BackCard> createState() => _BackCardState();
}
class _BackCardState extends State<BackCard> {


  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MaineAxisAlignment.center,
      children: [
        BlocListener<NewFlashCardBloc,NewFlashCardState>(
  listener: (context, state) {
    if(state is NewFlashCardInitial && !state.isVideo){
      context.read<VideoPlayBloc>().add(CancelVideo());
    }
  },
  child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 30,),
              const CardTitle(
                urlImage: 'assets/images/input.svg',
                title: 'Text',
              ),
              const SizedBox(height: 10,),
              questionText(context),
              const SizedBox(height: 30,),
              CardTitle(
                urlImage: 'assets/images/image.svg',
                title: 'Image/Video',
                iconButton: IconButton(
                  onPressed: (){
                    context.read<VideoPlayBloc>().add(PauseVideo());
                    context.read<NewFlashCardBloc>().add(AddImage(isFont: false));
                  }
                  , icon: SvgPicture.asset(
                  'assets/images/add.svg',
                  fit: BoxFit.contain,
                ),),
              ),
              const SizedBox(height: 30,),
              BlocBuilder<NewFlashCardBloc, NewFlashCardState>(
                builder: (context, state) {
                  if(state is NewFlashCardInitial && state.answerImage!=null){
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.width/2,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  width: 2
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 2,
                                    color: Colors.black
                                )
                              ],
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: !state.isVideo
                                  ? Image.file(
                                File(state.answerImage!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  );
                                },
                              ) : MyVideoPlay(videoUrl: state.answerImage!)
                          )

                        ),
                        const SizedBox(height: 30,)
                      ],
                    );
                  }
                 return Container();
                },
              ),
              CardTitle(
                urlImage: 'assets/images/record.svg',
                title: 'Audio file',
                iconButton: IconButton(
                  onPressed: (){
                    context.read<NewFlashCardBloc>().add(AddFile());
                  }
                  , icon: SvgPicture.asset(
                  'assets/images/add.svg', // Đường dẫn đến tệp SVG của bạn
                  fit: BoxFit.contain, // Cách hiển thị icon
                ),),
              ),
              BlocBuilder<NewFlashCardBloc, NewFlashCardState>(
                builder: (context, state) {
                  if(state is NewFlashCardInitial && state.answerAudio!=null){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: MyAudioPlayer(audioPath: state.answerAudio!,));
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 30,),
              const CardTitle(
                urlImage: 'assets/images/color.svg',
                title: 'Color',
              ),

              const SizedBox(height: 10,),
              const _ListColor()
            ],
          ),
        ),
),


      ],
    );


  }

  Widget questionText(BuildContext context){
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFC9FA85),
          border: Border.all(
              color: Colors.black,
              width: 2
          ),
          boxShadow: const[
            BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 2
            )
          ]
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: '...',
          hintStyle: TextStyle(
            fontSize: 40,  // Kích thước của text gợi ý
            color: Colors.black,  // Màu sắc của hintText
          ),
          border: InputBorder.none,  // Bỏ viền
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),  // Căn chỉnh nội dung bên trong
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 20
        ),
        onChanged: (value){
          context.read<NewFlashCardBloc>().add(AnswerChanged(value));
        },
      ),
    );
  }
}
class _ListColor extends StatefulWidget{

  const _ListColor();

  @override
  State<_ListColor> createState() => _ListColorState();
}

class _ListColorState extends State<_ListColor> {
  List<Color> items=[
    const Color(0xFFFA85BE),
    const Color(0xFFFA8585),
    const Color(0xFFFABC85),
    const Color(0xFFC9FA85),
    const Color(0xFF85FA9A),
    const Color(0xFF8985FA),
    const Color(0xFFC385FA)
  ];

  var selectedIndex ;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              context.read<NewFlashCardBloc>().add(ColorAnswerChanged(items[index].toString()));
            },
            //splashColor: ,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: items[index],
                  borderRadius: BorderRadius.circular(15), // Bo góc
                  border: Border.all(
                    color: index != selectedIndex ? Colors.transparent : Colors.black,
                    width: 2,
                  ),
                  boxShadow: index == selectedIndex
                      ? const [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 2,
                      color: Colors.black, // Thêm bóng khi được chọn
                    ),
                  ]
                      : const [],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

