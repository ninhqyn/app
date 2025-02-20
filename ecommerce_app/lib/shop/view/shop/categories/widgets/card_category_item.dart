import 'package:ecommerce_app/app.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardCategoryItemItem extends StatelessWidget{
  const CardCategoryItemItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       context.read<ShopBloc>().add(SelectCategoriesEvent('11'));
      },
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow:  [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4.0,
                  offset: const Offset(1, 1)
              )
            ]
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'New',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/image1.png',
                  width: MediaQuery.of(context).size.width/2,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        )

        ,
      ),
    );
  }

}