import 'package:address_repository/address_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:category_repository/category_repository.dart';
import 'package:color_repository/color_repository.dart';
import 'package:ecommerce_app/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/bag/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bag/bloc/check_out/check_out_bloc.dart';
import 'package:ecommerce_app/bag/bloc/shipping_address/shipping_address_bloc.dart';
import 'package:ecommerce_app/favorites/bloc/favorites_bloc.dart';
import 'package:favorite_repository/favorite_repository.dart';
import 'package:ecommerce_app/config/routes/routes.dart';
import 'package:ecommerce_app/config/routes/routes_name.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:product_api/product_api.dart';
import 'package:product_repository/product_repository.dart';
import 'package:product_type_repository/product_type_repository.dart';
import 'package:size_repository/size_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vn_repository/vn_repository.dart';
import 'bag/bloc/form_address/form_address_bloc.dart';
class App extends StatefulWidget{
  const App({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  late final SizeRepository _sizeRepository;
  late final FavoriteRepository _favoriteRepository;
  late final ProductRepository _productRepository;
  late final ProductTypeRepository _productTypeRepository;
  late final ColorRepository _colorRepository;
  late final CategoryRepository _categoryRepository;
  late final CartRepository _cartRepository;
  late final VnRepository _vnRepository;
  late final AddressRepository _addressRepository;
  late final OrderRepository _orderRepository;
  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository(
      AuthenticationApiClient(),
        AuthenticationLocalDataSource(widget.sharedPreferences)

    );
    _userRepository = UserRepository();
    //
    _sizeRepository = SizeRepository(sizeApiClient: SizeApiClient());
    _favoriteRepository = FavoriteRepository(favoriteApiClient: FavoriteApiClient());
    _productRepository = ProductRepository(productApiClient: ProductApiClient());
    _productTypeRepository = ProductTypeRepository(apiClient: ProductTypeApiClient());
    _colorRepository = ColorRepository(colorApiClient: ColorApiClient());
    _categoryRepository = CategoryRepository(categoryApiClient: CategoryApiClient());
    _cartRepository = CartRepository(cartApiClient: CartApiClient());
    _vnRepository = VnRepository(VnApiClient());
    _addressRepository = AddressRepository(addressApiClient: AddressApiClient());
    _orderRepository = OrderRepository(orderApiClient: OrderApiClient());
  }
  @override
  void dispose() {
    _productRepository.dispose();
    _cartRepository.dispose();
    _addressRepository.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _authenticationRepository,
        ),
        RepositoryProvider(
          create: (context) =>_userRepository,
        ),
        RepositoryProvider(
          create: (context) =>_sizeRepository,
        ),
        RepositoryProvider(
          create: (context) =>_favoriteRepository,
        ),
        RepositoryProvider(
          create: (context) =>_productRepository,
        ),
        RepositoryProvider(
          create: (context) =>_productTypeRepository,
        ),
        RepositoryProvider(
          create: (context) =>_colorRepository,
        ),
        RepositoryProvider(
          create: (context) =>_categoryRepository,
        ),
        RepositoryProvider(
          create: (context) =>_vnRepository,
        ),
        RepositoryProvider(
          create: (context) =>_addressRepository,
        ),
        RepositoryProvider(
          create: (context) =>_orderRepository,
        ),
      ],
      child: MultiBlocProvider(
          providers: [

            RepositoryProvider(
                create: (_)=>AuthenticationBloc(
                    authenticationRepository: _authenticationRepository,
                    userRepository: _userRepository
                )..add(AuthenticationRequested())
            ),
            RepositoryProvider(
                create: (_)=>FavoritesBloc(
                    productRepository: _productRepository,
                    authenticationRepository:_authenticationRepository,
                    favoriteRepository:_favoriteRepository,
                productTypeRepository: _productTypeRepository)
            ),
            RepositoryProvider(
                create: (_)=>CartBloc(
                    authenticationRepository: _authenticationRepository,
                    cartRepository: _cartRepository,
                    productRepository: _productRepository)
            ),
            RepositoryProvider(
                create: (_)=>ShippingAddressBloc(
                    authenticationRepository: _authenticationRepository,
                    addressRepository: _addressRepository)
            ),
            RepositoryProvider(
                create: (_)=>CheckOutBloc(
                    addressRepository: _addressRepository,
                    authenticationRepository: _authenticationRepository,
                    orderRepository: _orderRepository)
            ),
          ],
          child: const AppView()),
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
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil(
                  RoutesName.myHomePage,
                      (route) => false, // Xoá tất cả các route cũ
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil(
                  RoutesName.loginPage,
                      (route) => false, // Xoá tất cả các route cũ
                );
                break;
              case AuthenticationStatus.unknown:
                _navigator.pushNamedAndRemoveUntil(
                  RoutesName.splashPage,
                      (route) => false, // Xoá tất cả các route cũ
                );
                break;
            }
          },
          child: child,
        );
      },
      initialRoute: RoutesName.splashPage,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}