
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bag/view/bag_page.dart';
import '../../favorites/favorites_page.dart';
import '../../home/view/home_page.dart';
import '../../profile/view/profile_page.dart';
import '../../shop/view/shop/shop_page.dart';
import '../bloc/navigator_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigatorBloc>(
      create: (context) => NavigatorBloc(),
      child: Builder(
        builder: (context) {
          // Sử dụng BlocBuilder bên trong Builder để đảm bảo context có thể truy cập Provider
          return Scaffold(
            body: SafeArea(
              child: HomePageView(),
            ),
            bottomNavigationBar: const MyNavigator(),
          );
        },
      ),
    );
  }
}


class MyNavigator extends StatefulWidget {
  const MyNavigator({super.key});

  @override
  State<MyNavigator> createState() => _MyNavigatorState();
}

class _MyNavigatorState extends State<MyNavigator> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = context.select((NavigatorBloc bloc) => bloc.state.selectedIndex);
    return BottomNavigationBar(
      selectedItemColor: Colors.red, // Selected item color
      unselectedItemColor: Colors.grey,
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
                'assets/images/home.svg',
                 color: selectedIndex == 0 ? Colors.red : Colors.grey,) ,
            label: 'Home'
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/shop.svg',
              color: selectedIndex == 1 ? Colors.red : Colors.grey,),
            label: 'Shop'
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/bag.svg',
              color: selectedIndex == 2 ? Colors.red : Colors.grey,),
            label: 'Bag'
        ),
        BottomNavigationBarItem(
           icon: SvgPicture.asset('assets/images/favorites.svg',
             color: selectedIndex == 3 ? Colors.red : Colors.grey,),
            label: 'Favorites'
        ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/profile.svg',
              color: selectedIndex == 4 ? Colors.red : Colors.grey,),
            label: 'Profile'
        ),

      ],
      currentIndex:selectedIndex,
      onTap: (index){
        context.read<NavigatorBloc>().add(NavigatorEvent(index));
      },
    );
  }
}

class HomePageView extends StatelessWidget {

  HomePageView({super.key});
 final List<Widget> _widgetOption = [
   const ShopPage(),
   const HomePage(),
   const BagPage(),
   const FavoritesPage(),
   const ProfilePage()
 ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigatorBloc, MyNavigatorState>(
      builder: (context, state) {
        return IndexedStack(
          index: state.selectedIndex,  // Chọn trang dựa trên index
          children: _widgetOption,  // Các trang được quản lý bởi IndexedStack
        );
      },
    );
  }

}
