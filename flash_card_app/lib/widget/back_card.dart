import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class BackFlashCard extends StatelessWidget{
  final double weight,height;
  final Widget image;
  BackFlashCard({super.key, required this.weight, required this.height, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.pink,
        elevation: 4,
        shadowColor: Colors.black,
        child:Container(
          width: weight,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2), // Đặt border cho card
            borderRadius: BorderRadius.circular(10), // Bo góc cho card
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Màu bóng
                blurRadius: 8, // Độ mờ của bóng
                offset: const Offset(0, 4), // Vị trí bóng
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height/2+height/10,
                  // Bo góc với bán kính 20
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: image,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text("day la a lads dssddsoi" ,style :TextStyle(
                        fontSize: 24
                    ),maxLines: 2,textAlign: TextAlign.center,),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/images/loa.svg',
                    fit: BoxFit.contain, // Cách hiển thị icon
                            ),
                ),
              ],
            ),
          ),
        )
    );
  }

}