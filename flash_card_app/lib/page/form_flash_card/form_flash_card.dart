import 'package:flash_card_app/features/video_play/bloc/video_play_bloc.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flash_card_app/widget/my_app_bar.dart';
import 'package:flash_card_app/widget/my_toggle_switch.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes_name.dart';
import '../../features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'back_card.dart';
import 'font_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FormFlashCard extends StatefulWidget {
  const FormFlashCard({super.key, required this.isAdd});

  final bool isAdd;

  @override
  State<FormFlashCard> createState() => _FormFlashCardState();
}

class _FormFlashCardState extends State<FormFlashCard> {
  Future<bool> requestPer(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      Permission.storage.request();
      if (await permission.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<NewFlashCardBloc, NewFlashCardState>(
      listener: (context, state) async {
        if (state is AddQuestionImageState) {
          bool hasPermission = await requestPer(Permission.storage);
          if (hasPermission) {
            print(state.isFont);
            Navigator.pushNamed(context, RoutesName.myPhoto,
                arguments: {'isFont': state.isFont});
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Quyền truy cập bộ nhớ bị từ chối!'))
            );
          }
        }
        if (state is AddFileState) {
          bool hasPermission = await requestPer(Permission.storage);
          if (hasPermission) {
            Navigator.pushNamed(context, RoutesName.myFilePage);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Quyền truy cập bộ nhớ bị từ chối!'))
            );
          }
        }

        //
        if(state is SaveButtonState){
          if(state.isValid){
            context.read<VideoPlayBloc>().add(PauseVideo());
            Navigator.pushNamed(context, RoutesName.myPreviewPage,arguments: {'card': state.flashCard!});

          }else{
            String textError = state.errorText!;
            ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                    content: Text(textError))
            );
          }
        }
      },
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            context.read<VideoPlayBloc>().add(CancelVideo());
            return true;
          },
          child: Scaffold(
              body: const NewFlashCardView(),
              bottomNavigationBar: bottomNavigator()
          ),
        ),

      ),
    );
  }

  Widget bottomNavigator() {
    return SizedBox(
      height: 100,
      child: Center(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 2
                    )
                  ]
              ),
              child: BlocBuilder<NewFlashCardBloc, NewFlashCardState>(
                builder: (context, state) {
                  if (state is NewFlashCardInitial) {
                    return MyToggleSwitch(state.index);
                  }
                  return MyToggleSwitch(2);
                },
              ))
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<NewFlashCardBloc>().add(FormInitial(isAdd: widget.isAdd));
  }
}

class NewFlashCardView extends StatefulWidget {
  const NewFlashCardView({super.key});

  @override
  State<NewFlashCardView> createState() => _NewFlashCardViewState();
}

class _NewFlashCardViewState extends State<NewFlashCardView> {
  void navigationPage(String route) {
    Navigator.pushNamed(context, route);
  }
  Widget _myAppBar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              context.read<VideoPlayBloc>().add(CancelVideo());
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
          Text('New Flash Card',style: TextStyle(
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
              context.read<NewFlashCardBloc>().add(SaveButtonEvent());
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
          ),],),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _myAppBar(context),
          BlocBuilder<NewFlashCardBloc, NewFlashCardState>(
            builder: (context, state) {
              if (state is NewFlashCardInitial) {
                return IndexedStack(
                  index: state.index,
                  children: const [
                    FontCard(),
                    BackCard()
                  ],
                );
              }
              return const IndexedStack(
                children: [
                  FontCard(),
                  BackCard()
                ],
              );
            },
          )


        ],
      ),
    );
  }
}

