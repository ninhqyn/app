import 'package:ecommerce_app/bag/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/product/bloc/product_detail_bloc.dart';
import 'package:ecommerce_app/product/widget/button_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModalAddToCart extends StatelessWidget{
  const ModalAddToCart({super.key, required this.productId, required this.productName});
  final int productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
  listener: (context, state) {
    if (state is CartAddedToCart) {
      // Hiển thị SnackBar khi sản phẩm đã được thêm vào giỏ hàng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thêm ${state.productName} vào giỏ hàng!')),
      );

      // Đóng BottomSheet sau khi thêm vào giỏ hàng
      Navigator.pop(context);
    }
    if (state is FailToAddToCart) {
      // Hiển thị SnackBar khi sản phẩm đã được thêm vào giỏ hàng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fail vào giỏ hàng!')),
      );

      Navigator.pop(context);
    }
  },
  builder: (context, state) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Expanded(
            child: Center(
              child: Text(productName,style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Select Color',style: TextStyle(fontSize: 12,
              fontWeight: FontWeight.bold),),
            ),
          ),
          const Expanded(flex: 3,child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SelectColor(),
          )),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Select Size',style: TextStyle(fontSize: 12,
                  fontWeight: FontWeight.bold),),
            ),
          ),
          const Expanded(flex: 3,child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SelectSize(),
          )),
          Expanded(
            flex: 3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                  builder: (context, state) {

                    // Trong ModalAddToCart
                    if (state is LoadedProductState) {
                      int colorId = state.colorSelected!.colorId;
                      int sizeId = state.sizeSelected!.sizeId;
                      String productName = state.productModel.product.name;
                      return ElevatedButton(
                        onPressed: () {
                           context.read<CartBloc>().add(AddToCart(colorId: colorId,sizeId: sizeId,productId: productId,productName:productName ));

                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('ADD TO CARD',style: TextStyle(color: Colors.white),),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('ADD TO CARD',style: TextStyle(color: Colors.white),),

                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
);
  }
}
class _SelectColor extends StatelessWidget {
  const _SelectColor();

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
class _SelectSize extends StatelessWidget {
  const _SelectSize({super.key});

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
            itemCount: state.sizes.length, // Số lượng item trong Grid
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  context.read<ProductDetailBloc>().add(SelectSize(index,state.sizes[index]));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: state.sizeSelectedIndex == index ? Colors.red :Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: state.sizeSelectedIndex == index ? Colors.transparent : Colors.grey
                      )
                  ),
                  child: Center(
                    child: Text(
                      state.sizes[index].name,
                      style: TextStyle(color: state.sizeSelectedIndex == index ?Colors.white : Colors.black),
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