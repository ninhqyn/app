import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class FaceBookButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 8,
                color: Colors.black.withOpacity(0.05)
            )
          ]
      ),
      child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(92, 64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),

          ),
          child: SvgPicture.asset(
              'assets/images/google_icon.svg')),
    );
  }

  const FaceBookButton({super.key});
}