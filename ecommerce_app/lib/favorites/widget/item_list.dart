import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../shop/models/product_model.dart';
class ItemList extends StatelessWidget{
  const ItemList({super.key, required this.onTap, required this.item});
  final VoidCallback onTap;
  final ProductModel item;
  @override
  Widget build(BuildContext context) {
    final String imageUrl = item.productImages.isNotEmpty
        ? item.productImages[0].imageUrl
        : 'https://via.placeholder.com/150';
   return Container(
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(8),
       boxShadow: [
         BoxShadow(
           offset: const Offset(0, 1),
           blurRadius: 25,
           color: Colors.black.withOpacity(0.08)
         )
       ]
     ),
     width: double.infinity,
     height: 116,
     child: Stack(
       clipBehavior: Clip.none,
       alignment: Alignment.bottomRight,
       children: [
         Row(
           children: [
             Expanded(
               child: ClipRRect(
                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
                 child: item.productImages.isNotEmpty
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
             ),
            Expanded(
               flex: 2,
               child: Padding(
                 padding: const EdgeInsets.all(10),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(item.product.brand,style: const TextStyle(
                           color: Colors.grey,
                           fontSize: 12
                         ),
                         ),
                         InkWell(
                           onTap: onTap,
                           child: SvgPicture.asset(
                             'assets/images/cancel.svg',width: 30,
                           ),
                         )
                       ],
                     ),
                     Text(item.product.name,style: const TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold
                     ),),
                     Text(item.product.basePrice.toString(),
                         style: const TextStyle(
                             fontSize: 12,
                             fontWeight: FontWeight.bold
                         )
                     ),
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
                   ],
                 ),
               ),)
           ],
         ),
         Positioned(
           bottom: -16,
           child: Container(
             width: 36,
             height: 36,
             padding: const EdgeInsets.all(8),
             decoration: const BoxDecoration(
               color: Colors.red,
               shape: BoxShape.circle
             ),
             child: Center(child: SvgPicture.asset('assets/images/bag.svg',color: Colors.white,)),
           ),
         )
       ],
     ) ,
   );
  }
}
