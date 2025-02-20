import 'package:authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/bag/view/check_out_page.dart';
import 'package:ecommerce_app/bag/view/order_success_page.dart';
import 'package:ecommerce_app/bag/view/shipping_address_page.dart';
import 'package:ecommerce_app/config/routes/routes.dart';
import 'package:ecommerce_app/config/routes/routes_name.dart';
import 'package:ecommerce_app/product/view/product_detail_page.dart';
import 'package:ecommerce_app/profile/view/settings_page.dart';
import 'package:ecommerce_app/rating/view/rating_page.dart';
import 'package:ecommerce_app/shop/view/filters/view/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'bag/view/add_shipping_address_page.dart';
import 'login/view/login_page.dart';
import 'main/view/my_home_page.dart';

class App extends StatefulWidget{
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _userRepository = UserRepository();
  }
  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _authenticationRepository,
      child: BlocProvider(
          create: (_)=>AuthenticationBloc(
              authenticationRepository: _authenticationRepository,
              userRepository: _userRepository)..add(AuthenticationRequested()),
          child: const AppView(),
      ),
    );
  }
}
class AppView extends StatefulWidget{
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Metropolis'
      ),
      debugShowCheckedModeBanner: false,
      //home: const MyHomePage(),
      // navigatorKey: _navigatorKey,
      // builder: (context, child) {
      //   return BlocListener<AuthenticationBloc, AuthenticationState>(
      //     listener: (context, state) {
      //       switch (state.status) {
      //         case AuthenticationStatus.authenticated:
      //           print(state.status);
      //           // _navigator.pushAndRemoveUntil<void>(
      //           //   MyHomePage.route(),
      //           //       (route) => false,
      //           // );
      //         case AuthenticationStatus.unauthenticated:
      //           print('login page');
      //           _navigator.pushAndRemoveUntil<void>(
      //             LoginPage.route(),
      //                 (route) => false,
      //           );
      //         case AuthenticationStatus.unknown:
      //           break;
      //       }
      //     },
      //     child: child,
      //   );
      // },
      // onGenerateRoute: (_) => SplashPage.route(),
      initialRoute: RoutesName.myHomePage,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}