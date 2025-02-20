import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class SignUpPage extends StatelessWidget{
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: SafeArea(
          child: Column(
            children: [
              Text('Sign up'),
              TextField(),
              TextField(),
              TextField(),
              Row(
                children: [
                  const Text('Already have an account?'),
                  SvgPicture.asset('assets/images/next.svg')
                ],
              )

            ],
          )),
    );
  }

}