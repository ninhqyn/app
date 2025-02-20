import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardTitle extends StatelessWidget {
  final String urlImage;
  final String title;
  final IconButton? iconButton;
  // Constructor với giá trị mặc định cho urlIcon
  const CardTitle({
    required this.urlImage,
    required this.title,
    this.iconButton,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                urlImage, // Dùng urlIcon hoặc mặc định
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        iconButton != null ? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const[
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 1
              )
            ],
            border: Border.all(
              color: Colors.black,
              width: 1
            ),
            color: const Color(0xFFC9FA85),
          ),
          child: iconButton,
        ) :Container(),
      ],
    );
  }
}
