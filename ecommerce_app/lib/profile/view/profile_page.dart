import 'package:ecommerce_app/profile/view/infor_page.dart';
import 'package:ecommerce_app/profile/view/order_details_page.dart';
import 'package:ecommerce_app/profile/view/order_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:OrderDetailsPage()
    );
  }
}

