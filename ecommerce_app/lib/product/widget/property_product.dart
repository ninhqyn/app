import 'package:flutter/material.dart';
class PropertyProduct extends StatelessWidget{
  const PropertyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('H&M',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),),
            Text('\$19.99',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),),
          ],
        ),
        const Text('Short black dress',style: TextStyle(
            color: Colors.grey,
            fontSize: 11
        ),),
        Row(
          children: List.generate(
            5,
                (index) => Icon(
              Icons.star,
              size: 16,
              color: index < 4 ? Colors.amber : Colors.grey,
            ),
          ),
        ),
        const Text('Short dress in soft cotton jersey with decorative buttons '
            'down the front and a wide, frill-trimmed square neckline with'
            ' concealed elastication.'
            ' Elasticated seam under the bust and short pu'
            'ff sleeves with a small frill trim.',
          maxLines: 5,
          style:TextStyle(
              fontSize: 14
          ),),
      ],
    );

  }

}