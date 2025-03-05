import 'package:ecommerce_app/login/view/login_page.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final sf = await SharedPreferences.getInstance();
  runApp( App(sharedPreferences: sf));
}


