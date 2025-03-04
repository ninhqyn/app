import 'package:authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/app.dart';
import 'package:ecommerce_app/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes/routes_name.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView( // Thêm SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/banner1.png'),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Matilda Brown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'matildabrown@mail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),
              _ItemProfile(
                title: 'My orders',
                subtitle: 'Already have 12 orders',
                onTap: () {
                  context.read<ProfileBloc>().add(NavigatorMyOrder());
                },
              ),
              _ItemProfile(
                title: 'Shipping addresses',
                subtitle: '3 addresses',
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.shippingAddressPage);
                },
              ),
              _ItemProfile(
                title: 'Payment methods',
                subtitle: 'Visa **34',
                onTap: () {},
              ),
              _ItemProfile(
                title: 'Promocodes',
                subtitle: 'You have special promocodes',
                onTap: () {},
              ),
              _ItemProfile(
                title: 'My reviews',
                subtitle: 'Reviews for 4 items',
                onTap: () {},
              ),
              _ItemProfile(
                title: 'Settings',
                subtitle: 'Notifications, password',
                onTap: () {
                  context.read<ProfileBloc>().add(NavigatorSetting());
                },
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if(state.status == AuthenticationStatus.unauthenticated){
                    Navigator.pushReplacementNamed(context, RoutesName.loginPage);
                    return;
                  }
                  print('error');

                },
                child: _ItemProfile(
                  title: 'Log out',
                  subtitle: '=> login page',
                  onTap: () {
                    context.read<AuthenticationBloc>().add(
                        AuthenticationLogout());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemProfile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ItemProfile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: const Color(0xFF9B9B9B).withOpacity(0.05),
          width: double.infinity,
        ),
      ],
    );
  }
}
