import 'package:flash_card_app/model/flash_card.dart';
import 'package:flash_card_app/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyPlayPage extends StatefulWidget {
  const MyPlayPage({super.key, required this.myLists});
  final List<Flashcard> myLists;

  @override
  State<MyPlayPage> createState() => _MyPlayPageState();
}

class _MyPlayPageState extends State<MyPlayPage> {
  late PageController _pageController; // Controller for PageView
  int _currentPage = 0; // Track the current page

  @override
  void initState() {
    super.initState();
    // Initialize the PageController
    _pageController = PageController(initialPage: 0);
    // Add a listener to update the current page when the user swipes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 1,
                      offset: Offset(1, 1),
                      color: Color(0xFF000000),
                    )
                  ],
                  shape: BoxShape.circle,
                  color: const Color(0xFFC9FA85),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/back.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Text(
              widget.myLists[0].listName.isNotEmpty
                  ? widget.myLists[0].listName
                  : 'empty',
              style: TextStyle(
                fontSize: 24,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1.0,
                    offset: const Offset(1, 1),
                  )
                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Expanded(
              flex: 3,
              child: Center(
                child: PageView.builder(
                  controller: _pageController, // Attach the PageController
                  itemCount: widget.myLists.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: MyFlashCard(
                        weight: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height * (2 / 3),
                        card: widget.myLists[index],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: _myNavigator(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myNavigator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              // Navigate to the previous flashcard
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(1, 1),
                    color: Color(0xFF000000),
                  )
                ],
                shape: BoxShape.circle,
                color: const Color(0xFFC9FA85),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/previous.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Text(
            '${_currentPage + 1}/${widget.myLists.length}', // Update the page number dynamically
            style: TextStyle(
              fontSize: 24,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 1.0,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Navigate to the next flashcard
              if (_currentPage < widget.myLists.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 1,
                    offset: Offset(1, 1),
                    color: Color(0xFF000000),
                  )
                ],
                shape: BoxShape.circle,
                color: const Color(0xFFC9FA85),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/next.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}