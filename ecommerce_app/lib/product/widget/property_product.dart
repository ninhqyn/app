import 'package:ecommerce_app/product/bloc/product_detail_bloc.dart';
import 'package:ecommerce_app/rating/view/rating_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyProduct extends StatelessWidget {
  const PropertyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if(state is LoadedProductState){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(state.productModel.product.name.toString(), style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),),
                  Text('${state.productModel.product.basePrice} vnđ', style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              Text(state.productModel.product.brand, style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11
              ),),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_){
                    return RatingPage(productId: state.productModel.product.productId);
                  }));
                },
                child: Row(
                  children: List.generate(
                    5,
                        (index) =>
                        Icon(
                          Icons.star,
                          size: 16,
                          color: index < 4 ? Colors.amber : Colors.grey,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(state.productModel.product.description,
                maxLines: 5,
                style: const TextStyle(
                    fontSize: 14
                ),),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );

      },
    );
  }

}