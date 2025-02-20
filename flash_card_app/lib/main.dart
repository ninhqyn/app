import 'package:flash_card_app/page/my_file_page.dart';
import 'package:flash_card_app/page/my_home_page.dart';
import 'package:flash_card_app/page/my_new_flash_card.dart';
import 'package:flash_card_app/page/my_photo_page.dart';
import 'package:flash_card_app/page/my_play_list_page.dart';
import 'package:flash_card_app/page/my_play_page.dart';
import 'package:flash_card_app/page/my_preview_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Itim'
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=>const MyHomePage(),
        '/new_flash_card':(context)=> const NewFlashCard(),
        '/preview':(context) => const MyPreviewPage(),
        '/file':(context) => const MyFile(),
        '/image':(context) => const MyPhotos(),
        '/playlist':(context) => const MyPlayListPage(),
        '/play':(context) => const MyPlayPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

