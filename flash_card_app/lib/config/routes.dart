import 'package:flash_card_app/config/routes_name.dart';
import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flash_card_app/page/form_flash_card/form_flash_card.dart';
import 'package:flash_card_app/page/my_file_page.dart';
import 'package:flash_card_app/page/my_home_page.dart';
import 'package:flash_card_app/page/my_photo_page.dart';
import 'package:flash_card_app/page/my_play_list_page.dart';
import 'package:flash_card_app/page/my_play_page.dart';
import 'package:flash_card_app/page/my_preview_page.dart';
import 'package:flutter/material.dart';
class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case RoutesName.myPhoto:
        if(args is Map<String, dynamic> && args.containsKey('isFont')){
          print('check is font');
          return MaterialPageRoute(builder: (context)=>MyPhotos(isFont: args['isFont'] as bool,));
        }
        return MaterialPageRoute(builder: (context) => const MyPhotos(isFont: false,));
      case RoutesName.myHomePage:
        return MaterialPageRoute(builder: (context)=>const MyHomePage());
      case RoutesName.myFormFlashCard:
        if(args is Map<String, dynamic> && args.containsKey('isAdd')){
          return MaterialPageRoute(builder: (context)=>FormFlashCard(isAdd: args['isAdd'] as bool,));

        }
        return MaterialPageRoute(builder: (context)=>const FormFlashCard(isAdd: false,));

      case RoutesName.myFilePage:
        return MaterialPageRoute(builder: (context)=>const MyFile());
      case RoutesName.myPlayListPage:
        return MaterialPageRoute(builder: (context)=>const MyPlayListPage());
      case RoutesName.myPreviewPage:
        if(args is Map<String, dynamic> && args.containsKey('card')){
          print('check is font');
          return MaterialPageRoute(builder: (context)=>MyPreviewPage(flashCard: args['card'] as Flashcard,));
        }
        return MaterialPageRoute(builder: (context){
          return const Scaffold(
            body: Center(
              child: Text('Flash Card Null'),
            ),
          );
        });
      case RoutesName.myPlayPage:
        if(args is Map<String, dynamic> && args.containsKey('myList')){
          return MaterialPageRoute(builder: (context)=>MyPlayPage(myLists: args['myList'] as List<Flashcard>,));
        }
        return MaterialPageRoute(builder: (context){
          return const Scaffold(
            body: Center(
              child: Text('Flash Card Null'),
            ),
          );
        });

      default:
        return MaterialPageRoute(builder: (context){
          return const Scaffold(
            body: Center(
              child: Text('No route generate'),
            ),
          );
        });
    }
  }
}