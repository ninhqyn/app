import 'package:ecommerce_app/bag/widget/item_promo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'input_promo_code.dart';
class ModalPromoCode extends StatelessWidget{
  const ModalPromoCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 40),
      height: MediaQuery.of(context).size.height/2,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 30,
            color: Colors.black.withOpacity(0.08)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PromoCodeInput(onSubmit: (value) { print(value);  },),
          const SizedBox(height: 40,),
          const Text('Your Promo Codes',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),),
          Expanded(child: ListView.separated(
            itemCount:10,
            itemBuilder: (context,index){
            return const ItemPromo();
          }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 20,); },))
        ],
      ),
    );
  }

}
