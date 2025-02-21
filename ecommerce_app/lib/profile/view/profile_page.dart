import 'package:ecommerce_app/profile/bloc/profile_bloc.dart';
import 'package:ecommerce_app/profile/view/infor_page.dart';
import 'package:ecommerce_app/profile/view/order_details_page.dart';
import 'package:ecommerce_app/profile/view/order_page.dart';
import 'package:ecommerce_app/profile/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadInfo()),
      child: const Scaffold(
          body: SafeArea(child: ProfilePageView())
      ),
    );
  }
}

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(onTap: (){
                    print('back');
                    if(state is OrderDetail){
                      context.read<ProfileBloc>().add(NavigatorBack(1));
                    }else{
                      context.read<ProfileBloc>().add(NavigatorBack(0));
                    }


                  },child: SvgPicture.asset('assets/images/back.svg')),
                  const Text('Profile'),
                  Container()
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _getCurrentPageIndex(state),
                children: const [
                  InfoPage(),
                  Center(child: CircularProgressIndicator()),
                  OrdersPage(),
                  SettingsPage(),
                  OrderDetailsPage()
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  
  int _getCurrentPageIndex(ProfileState state) {
    if (state is ProfileInitial) {
      return 0;  
    }
    if (state is Loading) {
      return 1;
    }
    if (state is MyOrder) {
      return 2;
    }
    if (state is Setting) {
      return 3;
    }
    if (state is OrderDetail) {
      return 4;
    }
    return 0;  // Mặc định là trang thông tin
  }
}

