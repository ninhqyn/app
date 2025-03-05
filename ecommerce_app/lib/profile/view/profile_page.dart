import 'package:authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/profile/bloc/profile_bloc.dart';
import 'package:ecommerce_app/profile/view/infor_page.dart';
import 'package:ecommerce_app/profile/view/order_details_page.dart';
import 'package:ecommerce_app/profile/view/order_page.dart';
import 'package:ecommerce_app/profile/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order_repository/order_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ProfileBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
        orderRepository: context.read<OrderRepository>()
      )
        ..add(LoadInfo()),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if(state is ProfileInitial){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset('assets/images/search.svg'),
                        )
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      InkWell(onTap: () {
                        print('back');
                        if (state is OrderDetail) {
                          context.read<ProfileBloc>().add(NavigatorBack(1));
                        } else {
                          context.read<ProfileBloc>().add(NavigatorBack(0));
                        }
                      }, child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset('assets/images/back.svg'),
                      )
                        ,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset('assets/images/search.svg'),
                      )
                    ],
                  );
                },
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
    if (state is OrderDetailState) {
      return 4;
    }
    return 0; // Mặc định là trang thông tin
  }
}

