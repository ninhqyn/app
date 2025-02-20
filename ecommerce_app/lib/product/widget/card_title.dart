import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget{
  final Text titleLeft;
  final Text titleRight;
  const CardTitle({super.key, required this.titleLeft, required this.titleRight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        titleLeft,
        titleRight
      ],
    );
  }

}