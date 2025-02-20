import 'package:ecommerce_app/home/widgets/card_item.dart';
import 'package:ecommerce_app/product/widget/button_more.dart';
import 'package:ecommerce_app/product/widget/card_title.dart';
import 'package:ecommerce_app/product/widget/image_product.dart';
import 'package:ecommerce_app/product/widget/selector_property.dart';
import 'package:flutter/material.dart';

import '../widget/property_product.dart';
class ProductDetailPage extends StatelessWidget{
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('name item'),
      ),
      body: const SafeArea(
          child: ProductDetailView()
      ),
      bottomNavigationBar: _BottomNavigator(),
    );
  }

}

class _BottomNavigator  extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -4),
              blurRadius: 8,
            )
          ]
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class ProductDetailView  extends StatelessWidget{
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.s,
        children: [
          const ImageProduct(),
          const SizedBox(height: 20,),
          const SelectorProperty(),
          const SizedBox(height: 30,),
          const PropertyProduct(),
          const SizedBox(height: 10,),
          const ButtonMore(title: 'Shipping info'),
          const ButtonMore(title: 'Support'),
          const SizedBox(height: 10,),
          const CardTitle(
              titleLeft: Text('You can also like this',style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              ),
              titleRight: Text('12 items',style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11
              ),)),
          _ListItem ()
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 260,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              return const CardItem(textTag: Text('-20%',
                style: TextStyle(
                    color: Colors.white
                ),), colorTag: Colors.red);
            })
    );
  }}