import 'package:ecommerce_app/app.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/models/product_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTypePage extends StatelessWidget{
  const ProductTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFDB3022),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1, 1),
                    blurRadius: 2
                  )
                ]
              ),
              child: const Center(
                child: Text('VIEW ALL ITEM',style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Choose category',style: TextStyle(
              color: Colors.grey,
              fontSize: 14
            ),
            ),
          ),
          ListView.builder(
              itemCount: 20,
              shrinkWrap: true,
              itemBuilder: (context,index){
            return InkWell(
              onTap: (){
                print('product type');
                context.read<ShopBloc>().add(SelectProductTypeEvent('11'));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                    child: Text('index : $index' ,style: const TextStyle(
                      fontSize: 16
                    ),),
                  ),
                  LinearProgressIndicator(
                    minHeight: 1,
                    value: 100,
                    color: const Color(0xFF9B9B9B).withOpacity(0.4)
                  )
                ],
              ),
            );
          })
        ],
      ),
    );
  }

}