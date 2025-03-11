import 'package:flash_card_app/config/routes_name.dart';
import 'package:flash_card_app/features/play_list/bloc/play_list_bloc.dart';
import 'package:flash_card_app/page/my_flash_card.dart';
import 'package:flash_card_app/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class MyPlayListPage extends StatelessWidget{
  const MyPlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => PlayListBloc(),
        child: Builder(
          builder: (blocContext) { // context mới trong phạm vi BlocProvider
            return BlocListener<PlayListBloc, PlayListState>(
              listener: (context, state) {
                if(state is SavePlayListSuccess){
                  Navigator.pushReplacementNamed(context, RoutesName.myHomePage);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Add Play List Success'))
                  );
                }
                if(state is SavePlayListFailure){

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message!))
                  );
                }
              },
              child: Scaffold(
              appBar: _appBar(blocContext), // Truyền context mới vào _appBar
              body: BlocBuilder<PlayListBloc, PlayListState>(
                builder: (context, state) {
                  if(state is PlayListInitial && state.listChoose.isNotEmpty){
                    final myCards = state.listChoose;
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
                          return MyFlashCard(
                            weight: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 2.5,
                            card: myCards[index],
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Image.asset('assets/images/NoItem.png'),
                  );
                },
              ),
            ),
);
          },
        ),
      ),
    );
  }
  Widget _dialogEnterName(BuildContext dialogContext,BuildContext currentContext){
    TextEditingController controller = TextEditingController();
    return AlertDialog(
      title: const Text('Enter Name Play List'),
      content: TextField(
        decoration: const InputDecoration(
          labelText: 'Name',
        ),
        controller: controller,
        onChanged: (value) {
          // You can handle the input here if needed
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            currentContext.read<PlayListBloc>().add(SavePlayList(controller.text));
            Navigator.pop(dialogContext); // Close the dialog
          },
          child: const Text('Save'),
        ),
      ],
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
              Text('New Play List',style: TextStyle(
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
                  final currentContext = context;
                  showModalBottomSheet(context: currentContext, builder:(modalContext){
                    return BlocProvider.value(
                      value: currentContext.read<PlayListBloc>(),
                      child: Container(
                          width: double.infinity,

                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30)
                              ),color: Color(0xFFC9FA85),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, -4),
                                    blurRadius: 4
                                )
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30,bottom: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(onTap: (){
                                  Navigator.pop(modalContext);
                                  final bloc = currentContext.read<PlayListBloc>();
                                  Navigator.push(currentContext,  MaterialPageRoute(
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: bloc,
                                        child: const MyFlashCardPage(),
                                      );
                                    },
                                  ),
                                  );

                                },child: const Text('Choose Flash Card',style: TextStyle(fontSize: 24),)
                                ),
                                const SizedBox(height: 10,),
                                BlocBuilder<PlayListBloc, PlayListState>(
                                  builder: (context, state) {
                                    if(state is PlayListInitial){
                                      if(state.listChoose.isNotEmpty){
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(modalContext); // Close the modal
                                            // Show the dialog to input the name
                                            showDialog(
                                              context: currentContext,
                                              builder: (dialogContext) {
                                                return _dialogEnterName(dialogContext,currentContext);
                                              },
                                            );
                                          },
                                          child: const Text(
                                            'Save',
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        );
                                      }
                                    }
                                    return InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text('No item selected'))
                                        );
                                        Navigator.pop(modalContext); // Close the modal
                                      },
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    );

                                  },
                                ),
                                const SizedBox(height: 10,),
                                InkWell(onTap: (){
                                  Navigator.pop(context);
                                },child: const Text('Cancel',style: TextStyle(fontSize: 24),)
                                )
                              ],
                            ),
                          )),
                    );
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
      ),);
  }

}