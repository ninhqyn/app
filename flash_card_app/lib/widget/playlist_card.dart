import 'dart:io';
import 'package:flash_card_app/config/routes_name.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flash_card_app/widget/card.dart';
import 'package:flash_card_app/custom/custom_clipper.dart';
import 'package:flutter/material.dart';

class PlayListCard extends StatelessWidget {
  final double heightFlashCard = 185;
  const PlayListCard({super.key, required this.myLists});
  final List<Flashcard> myLists;

  Color hexStringToColor(String colorString) {
    String hexColor = colorString.replaceAll("Color(", "").replaceAll(")", "");
    return Color(int.parse(hexColor));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Check if list is empty
        if (myLists.isEmpty)
          const Text(
            'empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        else ...[
          // Ensure you are safely accessing elements from the list
          if (myLists.isNotEmpty)
            if (myLists.length == 1)
              Transform.rotate(
                angle: 0.0,
                child: _fontCard(myLists[0]),
              ),
          if (myLists.length == 2) ...[
            ClipPath(
              clipper: MyClip2(),
              child: Transform.rotate(
                angle: 0.2,
                child: _fontCard(myLists[1]),
              ),
            ),
            Transform.rotate(
              angle: 0.0,
              child: _fontCard(myLists[0]),
            ),
          ],
          if (myLists.length > 2) ...[
            ClipPath(
              clipper: LeftClip(),
              child: Transform.rotate(
                angle: 0.4,
                child: _fontCard(myLists[2]),
              ),
            ),
            ClipPath(
              clipper: MyClip2(),
              child: Transform.rotate(
                angle: 0.2,
                child: _fontCard(myLists[1]),
              ),
            ),
            Transform.rotate(
              angle: 0.0,
              child: _fontCard(myLists[0]),
            ),
          ],
        ],

        // Play button
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
                  offset: Offset(2, 2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.myPlayPage, arguments: {'myList': myLists});
              },
              style: OutlinedButton.styleFrom(
                elevation: 3,
                shadowColor: Colors.black.withOpacity(0.2),
                side: const BorderSide(color: Colors.black, width: 2),
                backgroundColor: const Color(0xFFC9FA85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Play',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fontCard(Flashcard card) {
    return Card(
      color: card.questionColor.isEmpty
          ? Colors.pink
          : hexStringToColor(card.questionColor),
      elevation: 4,
      shadowColor: Colors.black,
      child: Container(
        width: 132, // Assuming this is the intended width
        height: heightFlashCard,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: heightFlashCard / 2 + heightFlashCard / 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(card.questionImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    card.question,
                    style: const TextStyle(fontSize: 24),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
