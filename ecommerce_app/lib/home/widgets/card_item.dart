import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:ecommerce_app/favorites/widget/card_add_favorites.dart';
import 'package:flutter/material.dart';

import '../../shop/models/product_model.dart';
class CardItem extends StatelessWidget {
  final Text textTag;
  final bool isFavorite;
  final Color colorTag;
  final ProductModel item;
  final GestureTapCallback function;
  const CardItem({required this.textTag, required this.colorTag,super.key, required this.item, required this.function, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight:Radius.circular(12),
          topLeft: Radius.circular(12)
        )
      ),
      margin: const EdgeInsets.only(left: 15),
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
                  child: Image.network(
                      item.productImages.isNotEmpty ?
                      item.productImages[0].imageUrl : '', // Đảm bảo có URL ảnh
                      width:double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        // Khi không thể tải ảnh từ network, sẽ hiển thị ảnh từ assets
                        return Image.asset(
                          'assets/images/image5.png', // Ảnh mặc định trong assets
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      })
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
                    child: !isFavorite ? InkWell(
                      onTap: function,
                      child: const Icon(
                        Icons.favorite_border, // Đây là icon viền, nên dùng cho NOT favorite
                        size: 20,
                        color: Colors.black54,
                      ),
                    ) : InkWell(
                      onTap: function,
                      child: Center(
                        child: SvgPicture.asset(''
                            'assets/images/favorite2.svg',width: 20,height: 20,),
                      )
                      )
                    ),
                  ),
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
                    children: [
                      // Hiển thị sao dựa trên trường rating
                      ...List.generate(
                        5,
                            (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < item.product.rating ? Colors.amber : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Hiển thị tổng số đánh giá
                      Text(
                        '(${item.product.totalSold > 99 ? '99+' : item.product.totalSold})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Brand name
                  Text(
                    item.product.brand,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  // Product name (Sử dụng TextOverflow.ellipsis và maxLines để giới hạn độ dài)
                   Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2, // Giới hạn chỉ hiển thị 1 dòng
                    overflow: TextOverflow.ellipsis, // Hiển thị dấu "..."
                  ),
                  // Price
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${item.product.basePrice}d',  // Giá cũ
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const TextSpan(
                          text: ' ', // Khoảng cách giữa giá cũ và giá mới
                        ),
                        TextSpan(
                          text: '${item.product.basePrice}d', // Giá mới
                          style: const TextStyle(
                            color: Colors.red, // Màu giá mới
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
