import 'package:app_audio/model/file_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.item});
  final FileModel item;
  // Công thức: MB = bytes / (1024 * 1024)
  String formatFileSize(int bytes) {
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB'; // Làm tròn 2 chữ số thập phân
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/images/head_phone.svg'),
              const SizedBox(
                width: 10,
              ),
              Text(item.name)
            ],
          ),
          Row(
            children: [
              Text(formatFileSize(item.size)),
              const SizedBox(
                width: 20,
              ),
              SvgPicture.asset('assets/images/more.svg'),
            ],
          )
        ],
      ),
    );
  }
}
