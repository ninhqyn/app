import 'package:ecommerce_app/favorites/widget/card_add_favorites.dart';
import 'package:ecommerce_app/shop/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class CardGrid extends StatelessWidget {
  const CardGrid({super.key, required this.productModel, required this.onTap});
  final VoidCallback onTap;
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {

    final String imageUrl = productModel.productImages.isNotEmpty
        ? productModel.productImages[0].imageUrl
        : 'https://via.placeholder.com/150';
    return SizedBox(
      height: 300,
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
                    child: productModel.productImages.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/image1.png',  // Đường dẫn đến hình ảnh trong assets
                          width: double.infinity,
                          fit: BoxFit.fill,
                        );
                      },
                    )
                        : Image.asset(
                      'assets/images/image2.png',  // Hình ảnh mặc định nếu không có hình ảnh trong danh sách
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Badge "New"
                  Positioned(
                    top: 0,
                    right: 2,
                    child: InkWell(
                        onTap: onTap
                        ,child: SvgPicture.asset('assets/images/cancel.svg'))
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: const Text('-30%',style: TextStyle(color: Colors.white),),
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
                          showModalBottomSheet(
                              context: context,
                              builder:(context){
                                return CardAddFavorites();
                              });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          child: Center(child: SvgPicture.asset('assets/images/add_to_cart.svg',color: Colors.white,)),
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
                      children: [
                        // Hiển thị sao dựa trên trường rating
                        ...List.generate(
                          5,
                              (index) => Icon(
                            Icons.star,
                            size: 16,
                            color: index < productModel.product.rating ? Colors.amber : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Hiển thị tổng số đánh giá
                        Text(
                          '(${productModel.product.totalSold > 99 ? '99+' : productModel.product.totalSold})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    // Brand name
                    Text(
                      productModel.product.brand,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    // Product name (Sử dụng TextOverflow.ellipsis và maxLines để giới hạn độ dài)
                    Text(
                      productModel.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1, // Giới hạn chỉ hiển thị 1 dòng
                      overflow: TextOverflow.ellipsis, // Hiển thị dấu "..."
                    ),
                    // Price
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${productModel.product.basePrice}d',  // Giá cũ
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,

                            ),
                          ),
                          const TextSpan(
                            text: '   ', // Khoảng cách giữa giá cũ và giá mới
                          ),
                          TextSpan(
                            text: '${productModel.product.basePrice}d', // Giá mới
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
      ),
    );
  }
}
