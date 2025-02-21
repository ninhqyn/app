import 'package:ecommerce_app/favorites/widget/card_add_favorites.dart';
import 'package:flutter/material.dart';

import '../../config/routes/routes_name.dart';
class CardItem extends StatelessWidget {
  final Text textTag;
  final Color colorTag;


  const CardItem({required this.textTag, required this.colorTag,super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, RoutesName.productDetail,arguments: 1);
      },
      child: SizedBox(
        height: 260,
        width: 150,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,  // chiếm 2/3 chiều cao
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/image1.png',
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Badge "New"
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorTag,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: textTag,
                        ),
                      ),
                    Positioned(
                      bottom: -12,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                                spreadRadius: 0,
                                color: Colors.black.withOpacity(0.1),
                              )
                            ]
                        ),
                        child: InkWell(
                          onTap: (){
                            showModalBottomSheet(context: context,builder: (_){
                              return const CardAddFavorites();
                            });
                          },
                          child: const Icon(
                            Icons.favorite_border,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Phần thông tin sản phẩm
              Expanded(
                flex: 1, // chiếm 1/3 chiều cao
                child: Padding(
                  padding: const EdgeInsets.only(left: 2,right: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating stars
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
                      // Brand name
                      const Text(
                        'Brand Name',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      // Product name (Sử dụng TextOverflow.ellipsis và maxLines để giới hạn độ dài)
                      const Text(
                        'Product Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1, // Giới hạn chỉ hiển thị 1 dòng
                        overflow: TextOverflow.ellipsis, // Hiển thị dấu "..."
                      ),
                      // Price
                      const Row(
                        children: [
                          Text(
                            '\$99.99',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                          SizedBox(width: 5,),
                          Text(
                            '\$99.99',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
