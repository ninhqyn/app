import 'dart:io';

import 'package:flash_card_app/config/routes_name.dart';
import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/widget/card_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class FontCard extends StatelessWidget {
  const FontCard({super.key});



  @override
  Widget build(BuildContext context) {
    return
     Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
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
                    onPressed: () {
                      context.read<NewFlashCardBloc>().add(AddImage(isFont: true));
                    }
                    , icon: SvgPicture.asset(
                    'assets/images/add.svg', // Đường dẫn đến tệp SVG của bạn
                    fit: BoxFit.contain, // Cách hiển thị icon
                  ),),
                ),
                const SizedBox(height: 10,),
                BlocBuilder<NewFlashCardBloc, NewFlashCardState>(
                  builder: (context, state) {
                    if(state is NewFlashCardInitial){
                      if(state.questionImage!=null){
                        return Container(
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
                            child: Image.file(
                              File(state.questionImage!),
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
                        );
                      }
                      return Container();

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
                const ListColor()
              ],
            ),
          ),


        ],

    );
  }

  Widget questionText(BuildContext context) {
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
            fontSize: 40, // Kích thước của text gợi ý
            color: Colors.black, // Màu sắc của hintText
          ),
          border: InputBorder.none, // Bỏ viền
          contentPadding: EdgeInsets.symmetric(
              vertical: 10, horizontal: 10), // Căn chỉnh nội dung bên trong
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 20
        ),
        onChanged: (value) {
          context.read<NewFlashCardBloc>().add(QuestionChanged(value));
        },
      ),
    );
  }
}

class ListColor extends StatefulWidget {

  const ListColor({super.key});

  @override
  State<ListColor> createState() => _ListColorState();
}

class _ListColorState extends State<ListColor> {
  List<Color> items = [
    const Color(0xFFFA85BE),
    const Color(0xFFFA8585),
    const Color(0xFFFABC85),
    const Color(0xFFC9FA85),
    const Color(0xFF85FA9A),
    const Color(0xFF8985FA),
    const Color(0xFFC385FA)
  ];

  var selectedIndex;

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
                String color = items[index].toString();
                context.read<NewFlashCardBloc>().add(ColorQuestionSelected(color));
              });
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
                    color: index != selectedIndex ? Colors.transparent : Colors
                        .black,
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

