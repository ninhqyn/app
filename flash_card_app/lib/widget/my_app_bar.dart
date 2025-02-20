import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class MyAppBar extends StatelessWidget{
  final String title;
  final String? routeName;
  final String? urlAction;

  const MyAppBar({
    super.key,required this.title,
    this.urlAction,
    this.routeName
});
  void navigationPage(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
  @override
  Widget build(BuildContext context) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
       InkWell(
       onTap: (){
          Navigator.pop(context);
       },
         child: Container(
           width: 30,
           height: 30,
           decoration:  BoxDecoration(
             boxShadow: const [BoxShadow(
               blurRadius: 1,
               offset: Offset(1, 1),
               color: Color(0xFF000000),
             )
             ],
             shape: BoxShape.circle,
             color:const Color(0xFFC9FA85),
             border: Border.all(
               color: Colors.black, // Màu border
               width: 1,  // Độ dày border
             ),
           ),
           child: Align(
             alignment: Alignment.center,
             child: SvgPicture.asset(
               'assets/images/back.svg', // Đường dẫn đến tệp SVG của bạn
               fit: BoxFit.contain, // Cách hiển thị icon
             ),
           ),
         ),
       ),
       Text(title,style: TextStyle(
           fontSize: 24,
           shadows: [
             Shadow(
                 color: Colors.black.withOpacity(0.2) ,
                 blurRadius: 1.0,
                 offset: const Offset(1, 1)
             )
           ]
       )),
       urlAction != null ? InkWell(
         onTap: (){
           if (routeName != null) {
             navigationPage(context, routeName!);
           }
         },
         child: Container(
           width: 30,
           height: 30,
           decoration:  BoxDecoration(
             boxShadow: const [BoxShadow(
               blurRadius: 1,
               offset: Offset(1, 1),
               color: Color(0xFF000000),
             )
             ],
             shape: BoxShape.circle,
             color:const Color(0xFFC9FA85),
             border: Border.all(
               color: Colors.black, // Màu border
               width: 1,  // Độ dày border
             ),
           ),
           child: Align(
             alignment: Alignment.center,
             child: SvgPicture.asset(
               urlAction!, // Đường dẫn đến tệp SVG của bạn
               fit: BoxFit.contain, // Cách hiển thị icon
             ),
           ),
         ),
       ):Container()],
   );
  }

}