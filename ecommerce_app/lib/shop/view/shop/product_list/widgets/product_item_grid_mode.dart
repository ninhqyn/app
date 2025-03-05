import 'package:flutter/material.dart';


import '../../../../../home/widgets/card_item.dart';
import '../../../../models/product_model.dart';

class ProductItemGridMode extends StatelessWidget {
  const ProductItemGridMode({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CardItem(
        function: (){},
        isFavorite: false,
        item: productModel,
        textTag: const Text('abc'),
        colorTag: Colors.red,
      ),
    );
  }
}
