import 'package:ecommerce_app/product/widget/button_more.dart';
import 'package:flutter/material.dart';

class CardAddFavorites extends StatelessWidget{
  const CardAddFavorites({super.key});

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: MediaQuery.of(context).viewInsets,
     child: Container(
       height: MediaQuery.of(context).size.height/2,
       width: double.infinity,
       decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.08),
             offset: const Offset(0, -4),
             blurRadius: 30
           )
         ],
         borderRadius: const BorderRadius.only(
           topRight: Radius.circular(20),
           topLeft: Radius.circular(20)
         )
       ),
       child:  Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           const Padding(
             padding: EdgeInsets.all(20),
             child: Text('Select size',style: TextStyle(
               color: Colors.black,
               fontSize:18,
               fontWeight: FontWeight.bold
             ),),
           ),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             height: MediaQuery.of(context).size.height / 5,
             width: double.infinity,

             child: GridView.builder(
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 3,
                 childAspectRatio: 5 / 2,
                 crossAxisSpacing: 20, // Horizontal space between items
                 mainAxisSpacing: 20, // Vertical space between items
               ),
               itemCount: 5,
               itemBuilder: (context, index) {
                 return Container(
                   width: MediaQuery.of(context).size.width / 4,
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey),
                     borderRadius: BorderRadius.circular(8),
                   ),
                 );
               },
             ),
           ),
           const ButtonMore(title: 'Size info'),
           Expanded(child: Center(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 50),
               child: ElevatedButton(onPressed: (){},
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.red,
                   minimumSize: const Size(double.infinity, 20)
                 ),
               child: const Text('ADD TO FAVORITES',style: TextStyle(
                 color: Colors.white,
                 fontSize: 16,
                 fontWeight: FontWeight.bold
               ),),),
             ),
           ))

         ],
       ),
     ),
   );
  }

}