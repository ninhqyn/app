import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../tab/radio_tab.dart';
import '../tab/ringtone_tab.dart';
import '../tab/video_tab.dart';

class MyAudio extends StatefulWidget {
  const MyAudio({super.key});

  @override
  State<MyAudio> createState() => _MyAudioState();
}

class _MyAudioState extends State<MyAudio> {
  final List<Widget> _widgetOption =[
    const TabRadio(),
    const RingtoneTab(),
    const VideoTab()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ToggleSwitch(
              initialLabelIndex: _currentIndex,
              totalSwitches: 3,
              labels: const ['Audio', 'Ringtone', 'Video'],
              onToggle: (index) {
                setState(() {
                  _currentIndex = index!;
                  print('switched to: $_currentIndex');
                });
              },
              activeBgColor: const [Colors.black], // Màu nền khi được chọn
              inactiveBgColor: Colors.white, // Màu nền khi không chọn
              activeFgColor: Colors.white, // Màu chữ khi được chọn
              inactiveFgColor: const Color(0xFFB2B2B2), // Màu chữ khi không chọn
              cornerRadius: 30.0, // Bo tròn góc
              minWidth: MediaQuery.of(context).size.width/2, // Chiều rộng tối thiểu để đủ hiển thị labels
              minHeight: 50.0, // Chiều cao của các phần tử
              fontSize: 16.0, // Kích thước font chữ
            ),
          ),
          _widgetOption[_currentIndex]
        ],
      ),
    );
  }
}
