import 'package:ecommerce_app/config/routes/routes_name.dart';
import 'package:ecommerce_app/login/view/login_page.dart';
import 'package:ecommerce_app/main/view/my_home_page.dart';
import 'package:ecommerce_app/shop/view/filters/view/brand_screen.dart';
import 'package:ecommerce_app/shop/view/filters/view/filter_page.dart';
import 'package:flutter/material.dart';
class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.myHomePage:
        return MaterialPageRoute(builder: (context)=>const MyHomePage());
      case RoutesName.loginPage:
        return MaterialPageRoute(builder: (context)=>const LoginPage());
      case RoutesName.filterPage:
        return MaterialPageRoute(builder: (context)=>const FilterPage());
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