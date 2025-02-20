import 'package:flutter/material.dart';

class ImageProduct extends StatelessWidget{
  const ImageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 1/2* MediaQuery.of(context).size.height,
      color: Colors.red,
    );
  }

}