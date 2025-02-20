import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class CardFile extends StatelessWidget{
  final bool isPlay ;
  final String title;

  const CardFile(this.isPlay,  {super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
       decoration: isPlay == true ? BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFC9FA85),
        border: Border.all(
          color: Colors.black,
          width: 2
        ),
        boxShadow: const [
           BoxShadow(
             offset: Offset(2, 2),
             blurRadius: 2
           )
        ]
      ):BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFC9FA85)
       ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/images/music.svg'),
                const SizedBox(width: 10,),
                Text(title,style: const TextStyle(fontSize: 24),)
              ],
            ),
            isPlay ? SvgPicture.asset('assets/images/play.svg'):SvgPicture.asset('assets/images/pause.svg'),

          ],
        ),
      ),
    );
  }
}