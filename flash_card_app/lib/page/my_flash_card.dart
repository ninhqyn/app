
import 'package:flash_card_app/features/play_list/bloc/play_list_bloc.dart';
import 'package:flash_card_app/widget/card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
class MyFlashCardPage extends StatefulWidget {

  const MyFlashCardPage({super.key});

  @override
  State<MyFlashCardPage> createState() => _MyFlashCardPageState();
}

class _MyFlashCardPageState extends State<MyFlashCardPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context),
          body: const MyFlashCardView()
      ),
    );
  }

  PreferredSize _appBar(BuildContext context){
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  context.read<PlayListBloc>().add(BackMyFlashCard());
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
              Text('My Flash Card',style: TextStyle(
                  fontSize: 24,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(0.2) ,
                        blurRadius: 1.0,
                        offset: const Offset(1, 1)
                    )
                  ]
              )),
              BlocBuilder<PlayListBloc, PlayListState>(
                builder: (context, state) {
                  if(state is PlayListInitial && state.listSelected.isNotEmpty){
                    return InkWell(
                      onTap: (){
                        context.read<PlayListBloc>().add(UpdateListChoose());
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
                            'assets/images/check.svg', // Đường dẫn đến tệp SVG của bạn
                            fit: BoxFit.contain, // Cách hiển thị icon
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();

                },
              )],
          )
      ),);
  }

  @override
  void initState() {
    super.initState();
    context.read<PlayListBloc>().add(NavigatorMyFlashCardEvent());
  }
}
class MyFlashCardView extends StatefulWidget{
  const MyFlashCardView({super.key});

  @override
  State<MyFlashCardView> createState() => _MyFlashCardViewState();
}

class _MyFlashCardViewState extends State<MyFlashCardView> {
  bool showRadio = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _myFlashcards(context);

  }

  Widget _myFlashcards(BuildContext context) {
    return BlocBuilder<PlayListBloc, PlayListState>(
      builder: (context, state) {
        if (state is PlayListInitial) {
          if (state.listCards.isEmpty) {
            return Center(child: Image.asset('assets/images/NoItem.png'));
          }
          final myCards = state.listCards;
          final listSelected = state.listSelected;

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 240,
              ),
              itemCount: myCards.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: () {
                    print('show o chon');
                    setState(() {
                      showRadio = true;
                    });
                  },
                  child: Stack(
                    children: [
                      MyFlashCard(
                        weight: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2.5,
                        card: myCards[index],
                      ),
                      if (showRadio)
                        Positioned(
                          right: 15,
                          top: 15,
                          child: InkWell(
                            onTap: () {
                              context.read<PlayListBloc>().add(
                                ChooseFlashCard(flashCard: myCards[index]),
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFC9FA85),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: BlocBuilder<PlayListBloc, PlayListState>(
                                builder: (context, state) {
                                  if (state is PlayListInitial) {
                                    int indexSelected =-1;
                                    for(int i=0;i<listSelected.length;i++){
                                      if(myCards[index].id == listSelected[i].id){
                                        indexSelected = i;
                                        break;
                                      }
                                    }
                                    if (indexSelected != -1) {
                                      return Center(
                                        child: Text(
                                          '${indexSelected + 1}', // Hiển thị index + 1
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return Center(
                                    child: Container(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }




}
class MyProgress extends StatelessWidget{
  final double value;

  const MyProgress({super.key,required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: LinearProgressIndicator(
          value: value,  // Progress value (from 0.0 to 1.0)
          minHeight: 5,      // Height of the progress bar
          backgroundColor: Colors.grey,  // Background color
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC9FA85)),
          borderRadius: value != 1.0 ? const BorderRadius.only(
              topRight: Radius.circular(2.5),
              bottomRight: Radius.circular(2.5)
          ):const BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),)),
    );
  }

}