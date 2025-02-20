import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class ButtonMore extends StatelessWidget{
  final String title;
  const ButtonMore({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
     height: 50,
     child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         LinearProgressIndicator(
             minHeight: 1,
             value: 100,
             color: const Color(0xFF9B9B9B).withOpacity(0.4)
         ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(title ,style: const TextStyle(
                   fontSize: 16
               ),),
               SvgPicture.asset('assets/images/baseline-keyboard_arrow_right-24px.svg')
             ],
           ),
         ),
         LinearProgressIndicator(
             minHeight: 1,
             value: 100,
             color: const Color(0xFF9B9B9B).withOpacity(0.4)
         )
       ],
     ),
   );
  }

}