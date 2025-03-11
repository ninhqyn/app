
import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/features/video_play/bloc/video_play_bloc.dart';
import 'package:flash_card_app/page/form_flash_card/form_flash_card.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class MyToggleSwitch extends StatefulWidget{

  int labelIndex;

  MyToggleSwitch(this.labelIndex, {super.key});

  @override
  State<MyToggleSwitch> createState() => _MyToggleSwitchState();
}

class _MyToggleSwitchState extends State<MyToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 119.0,
      minHeight: 50,
      initialLabelIndex: widget.labelIndex ,
      cornerRadius: 15,
      borderColor: const [
        Colors.black
      ],
      borderWidth: 2,
      // activeFgColor: Colors.black,
      inactiveBgColor: Colors.white,
      //inactiveFgColor: Colors.white,
      radiusStyle: true,
      totalSwitches: 2,
      labels: const ['Font', 'Back'],
      //icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
      activeBgColors: const [[Color(0xFFC9FA85)],[Color(0xFFC9FA85)]],
      customTextStyles:[
        widget.labelIndex == 0 ?
        const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900) :
        const TextStyle(
            color: Colors.black,
            fontSize: 20.0),
        widget.labelIndex == 1 ? const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900
        ):
        const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        )
      ],
      activeBorders: const [
        Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          left: BorderSide(color: Colors.black, width: 2.0),
          right: BorderSide(color: Colors.black, width: 4.0),
        ),Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          left: BorderSide(color: Colors.black, width: 4.0),
          right: BorderSide(color: Colors.black, width: 2.0),
        )
      ],
      onToggle: (index) {
        setState(() {
          context.read<NewFlashCardBloc>().add(ToggleSelected(index!));
          context.read<VideoPlayBloc>().add(PauseVideo());
        });
      },
    );
  }
}