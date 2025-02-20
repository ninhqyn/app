import 'package:flash_card_app/widget/card.dart';
import 'package:flash_card_app/custom/custom_clipper.dart';
import 'package:flutter/material.dart';

class PlayListCard extends StatelessWidget{
  final double heightFlashCard =185;
  const PlayListCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: LeftClip(),
          child: Transform.rotate(
            angle: 0.4, // Góc xoay, thay đổi giá trị này để xoay theo ý muốn
            child:  FlashCard(weight: 133,height: 185,image: Image.asset('assets/images/rose.jpg',fit: BoxFit.fill,)), // Thẻ FlashCard thứ hai, đã xoay
          ),
        ),

        ClipPath(
          clipper: MyClip2(),
          child: Transform.rotate(
            angle: 0.2, // Góc xoay, thay đổi giá trị này để xoay theo ý muốn
            child:  FlashCard(weight: 132,height: 185,image: Image.asset('assets/images/j97.jpg',fit: BoxFit.fill,)), // Thẻ FlashCard thứ hai, đã xoay
          ),
        ),
        FlashCard(weight: 132,height: 185,image: Image.asset('assets/images/hoasen.jpg',fit: BoxFit.fill,)),

        //FlashCard(weight: 132,height: 185,image: Image.asset('assets/images/j97.jpg',fit: BoxFit.fill,)), // Thẻ FlashCard thứ hai, đã xoay
        Positioned(
          top: heightFlashCard,
            child: Container(
              height: 42,
              width: 99,
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(2,2),
                    blurRadius: 2
                  )
                ]
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/play');
                },
                style: OutlinedButton.styleFrom(
                  elevation: 3,
                  shadowColor: Colors.black.withOpacity(0.2),
                  side: const BorderSide(
                      color: Colors.black, width: 2
                  ),
                  backgroundColor: const Color(0xFFC9FA85),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Play',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            )

        ),

      ],
    );
  }

}