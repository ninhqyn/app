
import 'package:flash_card_app/widget/card.dart';
import 'package:flash_card_app/widget/playlist_card.dart';
import 'package:flutter/material.dart';

import '../widget/my_title.dart';

class MyHomePage extends StatelessWidget {

  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('HomePage'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient:  LinearGradient(
                    colors:[Color(0xFFC9FA85),Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyTitle('My Playlist', '/playlist', ImageIcon(AssetImage('assets/images/folder.png'))),
                  SizedBox(
                   height: 235,
                    child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          return const Padding(
                            padding: EdgeInsets.only(right: 20,left: 20),
                            child: PlayListCard(),
                          );
                        })
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const MyProgress(value: 0.5),

                  const SizedBox(
                    height: 30,
                  ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Flashcards',style: TextStyle(
                          fontSize: 24,
                          shadows: [
                            Shadow(
                                color: Colors.black.withOpacity(0.2) ,
                                blurRadius: 1.0,
                                offset: const Offset(1, 1)
                            )
                          ]
                      )),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, '/new_flash_card');
                            },
                            child: const Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ImageIcon(AssetImage('assets/images/add.png'),size: 14,)
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Tắt cuộn trong GridView
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 240,
                      ),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return FlashCard(
                          weight: 170,
                          height: 240,
                          image: Image.asset('assets/images/hoasen.jpg', fit: BoxFit.fill),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
class MyProgress extends StatelessWidget{
  final double value;

  const MyProgress({super.key,required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: LinearProgressIndicator(
          value: value,  // Progress value (from 0.0 to 1.0)
          minHeight: 5,      // Height of the progress bar
          backgroundColor: Colors.grey,  // Background color
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC9FA85)),
          borderRadius: value != 1.0 ? const BorderRadius.only(
              topRight: Radius.circular(2.5),
              bottomRight: Radius.circular(2.5)
          ):const BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),)),
    );
  }
  
}