import 'package:flutter/material.dart';

class TitlePage extends StatelessWidget{
  final String title;

  const TitlePage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(title,style: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    );
  }

}