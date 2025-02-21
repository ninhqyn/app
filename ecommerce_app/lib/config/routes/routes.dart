import 'package:ecommerce_app/bag/view/add_shipping_address_page.dart';
import 'package:ecommerce_app/bag/view/check_out_page.dart';
import 'package:ecommerce_app/bag/view/order_success_page.dart';
import 'package:ecommerce_app/bag/view/shipping_address_page.dart';
import 'package:ecommerce_app/config/routes/routes_name.dart';
import 'package:ecommerce_app/login/view/login_page.dart';
import 'package:ecommerce_app/main/view/my_home_page.dart';
import 'package:ecommerce_app/product/view/product_detail_page.dart';
import 'package:flutter/material.dart';

import '../../filters/view/filter_page.dart';
class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.myHomePage:
        return MaterialPageRoute(builder: (context)=>const MyHomePage());
      case RoutesName.loginPage:
        return MaterialPageRoute(builder: (context)=>const LoginPage());
      case RoutesName.productDetail:
        return MaterialPageRoute(builder: (context)=>const ProductDetailPage());
      case RoutesName.checkOutPage:
        return MaterialPageRoute(builder: (context)=>const CheckOutPage());
      case RoutesName.shippingAddressPage:
        return MaterialPageRoute(builder: (context)=>const ShippingAddressPage());
      case RoutesName.addShippingAddressPage:
        return MaterialPageRoute(builder: (context)=> AddShippingAddressPage());
      case RoutesName.orderSuccessPage:
        return MaterialPageRoute(builder: (context)=>const OrderSuccessPage());

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