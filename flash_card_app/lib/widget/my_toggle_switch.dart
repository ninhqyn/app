import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
      labels: ['Font', 'Back'],
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
          widget.labelIndex = index!;
        });

        print('switched to: $index');
      },
    );
  }
}