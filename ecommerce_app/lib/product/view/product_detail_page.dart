import 'package:ecommerce_app/home/bloc/home_bloc.dart';
import 'package:ecommerce_app/home/widgets/card_item.dart';
import 'package:ecommerce_app/product/bloc/product_detail_bloc.dart';
import 'package:ecommerce_app/product/widget/button_more.dart';
import 'package:ecommerce_app/product/widget/card_title.dart';
import 'package:ecommerce_app/product/widget/image_product.dart';
import 'package:ecommerce_app/product/widget/selector_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api/product_api.dart';
import 'package:product_repository/product_repository.dart';

import '../widget/modal_add_to_cart.dart';
import '../widget/property_product.dart';
class ProductDetailPage extends StatefulWidget{
  const ProductDetailPage({super.key, required this.productId});
 final int productId;
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailBloc>().add(FetchedProduct(widget.productId));
  }
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
          child: BlocBuilder<ProductDetailBloc,ProductDetailState >(
            builder: (context, state) {
              if(state is LoadedProductState){
                return ElevatedButton(
                  onPressed:  (){
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
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: PropertyProduct(),
          ),
          const SizedBox(height: 10,),
          const ButtonMore(title: 'Shipping info'),
          const ButtonMore(title: 'Support'),
          const SizedBox(height: 10,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CardTitle(
                titleLeft: Text('You can also like this',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                ),
                titleRight: Text('12 items',style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11
                ),)),
          ),
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
              // return  CardItem(
              //     textTag: Text('-20%',
              //   style: TextStyle(
              //       color: Colors.white
              //
              return Text('abc');
            })
    );
  }}