import 'package:app_audio/page/choose_video_page.dart';
import 'package:app_audio/page/export_page.dart';
import 'package:app_audio/page/play_audio_page.dart';
import 'package:app_audio/page/play_video_page.dart';
import 'package:app_audio/page/ringtone_page.dart';
import 'package:app_audio/page/wifi_transfer.dart';
import 'package:app_audio/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'naviagtion/my_audio.dart';
import 'naviagtion/stream_by_link.dart';
import 'naviagtion/up_load.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Sura'
      ),
      //initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context) => const MyHomePage(),
        '/play-video':(context) => const VideoPlayerScreen(),
        '/export-successful':(context) => const ExportPage(),
        '/play-audio':(context) => const PlayPage(),
        '/create-ringtone':(context) => const RingTonePage(),
        '/loading':(context) => const CustomLoadingWidget(),
        '/choose-video':(context) => const ChooseVideo(),
        '/wifi-transfer':(context) =>  const WifiTransferScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Các nội dung của mỗi tab
  final List<Widget> _widgetOptions = <Widget>[
    const StreamVideo(),
    const UploadFile(),
    const MyAudio(),
  ];
  int _selectedIndex = 1;
  void _onItemTapped(index){
    setState(() {
      _selectedIndex = index;
      print(index);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar:Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(1, 1)
            )
          ],
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: ()=>_onItemTapped(0),
                  child: SizedBox(
                    height: 77,
                    width: MediaQuery.of(context).size.width/3,
                    child: Stack(
                      children: [
                        Align(alignment: Alignment.center,child: SvgPicture.asset('assets/images/internet.svg',color: _selectedIndex==0? Colors.black:const Color(0xFFB2B2B2),)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: ()=>_onItemTapped(1),
                  child: SizedBox(
                    height: 77,
                    width: MediaQuery.of(context).size.width/3,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        if(_selectedIndex==1) Positioned(
                          top: -23,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)
                                )
                            ),
                            height:100,
                            width: MediaQuery.of(context).size.width/3,
                          ),
                        ),
                        SvgPicture.asset('assets/images/Vglq7u.tif.svg',color: _selectedIndex==1? Colors.white :const Color(0xFFB2B2B2),),

                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: ()=>_onItemTapped(2),
                  child: SizedBox(
                    height: 77,
                    width: MediaQuery.of(context).size.width/3,
                    child: Stack(
                      children: [
                        Align(alignment: Alignment.center,child: SvgPicture.asset('assets/images/fa0BxB.tif.svg',color: _selectedIndex==2? Colors.black :const Color(0xFFB2B2B2))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
