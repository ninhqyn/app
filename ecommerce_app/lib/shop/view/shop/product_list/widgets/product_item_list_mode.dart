import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../models/product_model.dart';
class ProductItemListMode extends StatelessWidget{
  const ProductItemListMode({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                offset: const Offset(0, 1),
                color: Colors.black.withOpacity(0.1)
            )
          ]
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                ),
                  child: Image.network(
                      productModel.productImages.isNotEmpty ?
                      productModel.productImages[0].imageUrl : '', // Đảm bảo có URL ảnh
                      width: 1 / 3 * MediaQuery.of(context).size.width,
                      height: double.infinity,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        // Khi không thể tải ảnh từ network, sẽ hiển thị ảnh từ assets
                        return Image.asset(
                          'assets/images/image5.png', // Ảnh mặc định trong assets
                          width: 1 / 3 * MediaQuery.of(context).size.width,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      })),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productModel.product.name,style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                    Text(productModel.product.brand,style: const TextStyle(
                        color:Colors.grey
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
                    Text('${productModel.product.basePrice} vnd',style:const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: -20,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color:Colors.black.withOpacity(0.2),
                        offset: const Offset(1, 1)
                    )
                  ]
              ),
              child: Center(child: SvgPicture.asset('assets/images/favorites_1.svg')),
            ),
          )
        ],
      ),
    );
  }

}
