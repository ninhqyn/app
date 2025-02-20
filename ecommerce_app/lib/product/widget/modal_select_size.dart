import 'package:flutter/material.dart';

class ModalSelectSize extends StatelessWidget{
  const ModalSelectSize({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      height: MediaQuery.of(context).size.height/2,
      child: Center(
        child: Text('modal button siz'),
      ),
    );
  }
}