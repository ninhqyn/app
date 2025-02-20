import 'package:flutter/material.dart';

import '../../../../../home/widgets/card_item.dart';

class ProductItemGridMode extends StatelessWidget{
  const ProductItemGridMode({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: CardItem(textTag: Text('abc'), colorTag: Colors.red),
    );
  }

}