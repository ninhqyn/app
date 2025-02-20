import 'package:flutter/material.dart';

class CardSale extends StatelessWidget{
  final String mainTitle;
  final String extraTitle;
  const CardSale({super.key, required this.mainTitle, required this.extraTitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFDB3022),
            boxShadow:  [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4.0,
                  offset: const Offset(1, 1)
              )
            ]
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mainTitle,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Text(
                extraTitle,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )

        ,
      ),
    );
  }
}