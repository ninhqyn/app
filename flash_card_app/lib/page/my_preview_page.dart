import 'package:flash_card_app/config/routes_name.dart';
import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/interface/media_controller.dart';
import 'package:flash_card_app/main.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import '../widget/card.dart';

class MyPreviewPage extends StatefulWidget{
  const MyPreviewPage({super.key, required this.flashCard});
  final Flashcard flashCard;
  @override
  State<MyPreviewPage> createState() => _MyPreviewPageState();
}

class _MyPreviewPageState extends State<MyPreviewPage> {
  MediaController? _mediaController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocListener<NewFlashCardBloc, NewFlashCardState>(
  listener: (context, state) {
    if(state is SaveFlashCardState && state.result){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message))
      );
      Navigator.pushReplacementNamed(context, RoutesName.myHomePage);
    }
    if(state is SaveFlashCardState && !state.result){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(state.message))
      );
    }

  },
  child: Scaffold(
        appBar:  _appBar(),
        body: Center(
          child: MyFlashCard(
              weight: MediaQuery.of(context).size.width-50,
              height: MediaQuery.of(context).size.height/1.8,
              card: widget.flashCard,
              onControllerReady: (controller){
                _mediaController = controller;
              },),

        ),
      ),
));
  }
  PreferredSize _appBar(){
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration:  BoxDecoration(
                    boxShadow: const [BoxShadow(
                      blurRadius: 1,
                      offset: Offset(1, 1),
                      color: Color(0xFF000000),
                    )
                    ],
                    shape: BoxShape.circle,
                    color:const Color(0xFFC9FA85),
                    border: Border.all(
                      color: Colors.black, // Màu border
                      width: 1,  // Độ dày border
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/back.svg', // Đường dẫn đến tệp SVG của bạn
                      fit: BoxFit.contain, // Cách hiển thị icon
                    ),
                  ),
                ),
              ),
              Text('Preview',style: TextStyle(
                  fontSize: 24,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(0.2) ,
                        blurRadius: 1.0,
                        offset: const Offset(1, 1)
                    )
                  ]
              )),
              InkWell(
                onTap: (){
                  _mediaController?.pauseAllMedia();
                  showModalBottomSheet(context: context, builder:(context){
                    return _modalBottomSheet();
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration:  BoxDecoration(
                    boxShadow: const [BoxShadow(
                      blurRadius: 1,
                      offset: Offset(1, 1),
                      color: Color(0xFF000000),
                    )
                    ],
                    shape: BoxShape.circle,
                    color:const Color(0xFFC9FA85),
                    border: Border.all(
                      color: Colors.black, // Màu border
                      width: 1,  // Độ dày border
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/preview_action.svg', // Đường dẫn đến tệp SVG của bạn
                      fit: BoxFit.contain, // Cách hiển thị icon
                    ),
                  ),
                ),
              )],
          )
      ),// Chiều cao của AppBar
    );
  }
  Widget _modalBottomSheet() {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30)
            ),
            color: Color(0xFFC9FA85),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, -4),
                  blurRadius: 4
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nút Save
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                   context.read<NewFlashCardBloc>().add(SaveFlashCard(widget.flashCard));
                  },
                  splashColor: const Color(0xFFB8E679),
                  highlightColor: const Color(0xFFA8DD67),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nút Add to List
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Xử lý Add to List
                    Navigator.pop(context);
                  },
                  splashColor: const Color(0xFFB8E679),
                  highlightColor: const Color(0xFFA8DD67),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Add to List',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nút Cancel
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  splashColor: Colors.red.withOpacity(0.3),
                  highlightColor: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
