import 'package:ecommerce_app/product/bloc/product_detail_bloc.dart';
import 'package:ecommerce_app/product/widget/button_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modal_add_to_cart.dart';

class ModalSelectColor extends StatelessWidget{
  const ModalSelectColor({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        ),
          color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 30,
            color: Colors.black.withOpacity(0.08)
          )
        ]
      ),
      height: MediaQuery.of(context).size.height/2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const Expanded(
            child: Text('Select Color',style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
          ),
          const Expanded(flex: 4,child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SelectSize(),
          )),
          const Expanded(child: ButtonMore(title: 'Color info')),
          Expanded(
            flex: 3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                  builder: (context, state) {
                    if(state is LoadedProductState){
                      return ElevatedButton(
                        onPressed:  (){
                          Navigator.pop(context);
                          final productDetailBloc = context.read<ProductDetailBloc>();
                          showModalBottomSheet(
                              context: context,
                              builder: (context){
                                return BlocProvider.value(
                                    value: productDetailBloc,
                                    child: ModalAddToCart(
                                        productId:state.productModel.product.productId ,
                                        productName:state.productModel.product.name
                                    ));
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('ADD TO CARD',style: TextStyle(color: Colors.white),),

                      );
                    }
                    return const Center(child:
                    CircularProgressIndicator(),);

                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _SelectSize extends StatelessWidget {
  const _SelectSize();

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ProductDetailBloc, ProductDetailState>(
  builder: (context, state) {
    if(state is LoadedProductState){
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 cột
            crossAxisSpacing: 10, // Khoảng cách giữa các cột
            mainAxisSpacing: 10, // Khoảng cách giữa các hàng
            childAspectRatio: 3/1
        ),
        itemCount: state.colors.length, // Số lượng item trong Grid
        itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  context.read<ProductDetailBloc>().add(SelectColor(index,state.colors[index]));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: state.colorSelectedIndex == index ? Colors.red :Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: state.colorSelectedIndex == index ? Colors.transparent : Colors.grey
                      )
                  ),
                  child: Center(
                    child: Text(
                      state.colors[index].name,
                      style: TextStyle(color: state.colorSelectedIndex == index ?Colors.white : Colors.black),
                    ),
                  ),
                ),
              );
        },
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );

  },
);
  }
}