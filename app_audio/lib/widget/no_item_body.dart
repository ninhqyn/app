import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class NoItem extends StatelessWidget{
  final String title;

  const NoItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(flex: 3,child: SvgPicture.asset('assets/images/no_audio.svg')),
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),const Spacer(flex: 2,)
      ],
    );
  }

}