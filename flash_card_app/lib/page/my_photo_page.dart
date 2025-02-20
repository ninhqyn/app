
import 'package:flash_card_app/widget/my_app_bar.dart';
import 'package:flutter/material.dart';
class MyPhotos extends StatelessWidget{
  const MyPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    double mainSpace = 10.0;
    int count = 3;
    double paddingHorizontal = 20.0;
   return SafeArea(child: Scaffold(
     appBar: const PreferredSize(
       preferredSize: Size.fromHeight(60.0), // Chiều cao của AppBar
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 20),
           child: MyAppBar(title: 'Photos')),
     ),
     body:SingleChildScrollView(
       child: Padding(
         padding:  EdgeInsets.symmetric(horizontal: paddingHorizontal),
         child: Padding(
           padding: const EdgeInsets.only(top: 20),
           child: GridView.builder(
             shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(), // Tắt cuộn trong GridView
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: count,
                 crossAxisSpacing: mainSpace,
                 mainAxisSpacing: mainSpace,
             ),
             itemCount: 20,
             itemBuilder: (context, index) {
               return Container(
                 decoration: BoxDecoration(
                   color: Colors.red,
                   borderRadius:BorderRadius.circular(15)
                 ), // Màu nền cho container bên trong
               );
             },
           ),
         ),
       ),
     )
   )
   );
  }

}
