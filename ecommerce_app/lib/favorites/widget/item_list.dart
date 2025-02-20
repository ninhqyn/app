import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class ItemList extends StatelessWidget{
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
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
                 child: Image.asset('assets/images/banner1.png',fit: BoxFit.fill,),
               ),
             ),
            Expanded(
               flex: 2,
               child: Padding(
                 padding: const EdgeInsets.all(10),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('LIME',style: TextStyle(
                           color: Colors.grey,
                           fontSize: 11
                         ),
                         ),
                         Icon(Icons.cancel)
                       ],
                     ),
                     const Text('Shirt',style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold
                     ),),
                     const Row(
                       children: [
                         Text('Color: ',style: TextStyle(
                           color: Colors.grey,
                           fontSize: 11
                         ),),
                         Text('Blue',style: TextStyle(
                           fontSize: 11,
                           fontWeight: FontWeight.bold
                         ),),
                         SizedBox(width: 20,),
                         Text('Color:',style: TextStyle(
                             color: Colors.grey,
                             fontSize: 11
                         ),),
                         Text('Blue',style: TextStyle(
                             fontSize: 11,
                             fontWeight: FontWeight.bold
                         ),),

                       ],
                     ),
                     Row(
                       children: [
                         const Text('32\$',style: TextStyle(
                           fontSize: 14,
                           fontWeight: FontWeight.bold
                         ),),
                         Row(
                           children: List.generate(5, (index){
                             return const Icon(Icons.star,color: Colors.yellow,);
                           }),
                         )
                       ],
                     )
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
