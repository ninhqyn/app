import 'package:address_repository/address_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:color_repository/color_repository.dart';
import 'package:ecommerce_app/bag/view/form_address_page.dart';
import 'package:ecommerce_app/bag/view/check_out_page.dart';
import 'package:ecommerce_app/bag/view/order_success_page.dart';
import 'package:ecommerce_app/bag/view/shipping_address_page.dart';
import 'package:ecommerce_app/config/routes/routes_name.dart';
import 'package:ecommerce_app/login/view/login_page.dart';
import 'package:ecommerce_app/main/view/my_home_page.dart';
import 'package:ecommerce_app/product/view/product_detail_page.dart';
import 'package:ecommerce_app/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api/product_api.dart';
import 'package:product_repository/product_repository.dart';
import 'package:size_repository/size_repository.dart';
import '../../bag/bloc/check_out/check_out_bloc.dart';
import '../../product/bloc/product_detail_bloc.dart';
class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.myHomePage:
        return MaterialPageRoute(builder: (context)=>const MyHomePage());
      case RoutesName.loginPage:
        return MaterialPageRoute(builder: (context)=>const LoginPage());
      case RoutesName.splashPage:
        return MaterialPageRoute(builder: (context)=>const SplashPage());
      case RoutesName.productDetail:
        final productId = settings.arguments as int?;
        if (productId == null) {
          throw Exception('ProductId is required');
        }
        return MaterialPageRoute(
          builder: (context) => MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (context) => ProductRepository(
                  productApiClient: ProductApiClient(),
                ),
              ),
              RepositoryProvider(
                create: (context) =>ColorRepository(
                 colorApiClient: ColorApiClient(),
                ),
              ),
              RepositoryProvider(
                create: (context) => SizeRepository(
                  sizeApiClient: SizeApiClient(),
                ),
              ),
            ],
            child: BlocProvider(
              create: (context) => ProductDetailBloc(
                context.read<ProductRepository>(),
                context.read<ColorRepository>(),
                context.read<SizeRepository>(),
              ),
              child: ProductDetailPage(productId:productId),
            ),
          ),
        );
      case RoutesName.checkOutPage:
        final order = settings.arguments as double?;
        if (order == null) {
          throw Exception('Order amount is required');
        }
        return MaterialPageRoute(
          builder: (context) => CheckOutPage(order:order),
        );
      case RoutesName.shippingAddressPage:
        return MaterialPageRoute(builder: (context)=>const ShippingAddressPage());
      // case RoutesName.addShippingAddressPage:
      //   return MaterialPageRoute(builder: (context)=> const FormAddressPage());
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