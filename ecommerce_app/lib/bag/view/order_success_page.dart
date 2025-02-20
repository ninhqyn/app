import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget{
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(child: Image.asset('assets/images/bags_success.png')),
            const Text('Success!',style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 34
            ),),
            const SizedBox(height: 20,),
            const Text('Your order will be delivered soon.',style: TextStyle(
              fontSize: 14
            ),),
            const Text('Thank you for choosing our app',style: TextStyle(
              fontSize: 14
            ),),
            const Spacer(flex: 2,)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
        child: ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50)
            ),
            child: const Text('CONTINUE SHOPPING',
              style: TextStyle(color: Colors.white),)
        ),
      ),
    );
  }

}