import 'package:ecommerce_app/bag/view/order_success_page.dart';
import 'package:flutter/material.dart';

import '../../config/routes.dart';

class CheckOutPage extends StatelessWidget{
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check out'),
      ),
      body: const CheckOutView(),
      bottomNavigationBar: _MyNavigator(),
    );
  }

}

class _MyNavigator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 100,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.red.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 8
                  )
                ]
            ),
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, RoutesName.orderSuccessPage);
              },
              child: const Center(
                child: Text('SUBMIT ORDER',style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckOutView extends StatelessWidget{
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _ShippingAddress()),
          Expanded(child: _Payment()),
          Expanded(child: _DeliveryMethod()),
          Expanded(child: _TotalInFor())
        ],
      ),
    );
  }
}

class _TotalInFor extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return const Column(
     mainAxisAlignment: MainAxisAlignment.spaceAround,
     children: [
       _Item(title:'Order',amount:'112\$'),
       _Item(title:'Delivery',amount:'15\$'),
       _Item(title:'Summary',amount:'127\$')
     ],
   );
  }
}

class _Item extends StatelessWidget{
  final String title;
  final String amount;

  const _Item({required this.title,required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: const TextStyle(
          fontSize: 14,
          color: Colors.grey
        ),),
        Text(amount,style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          fontWeight: FontWeight.bold
        ),)
      ],
    );
  }
}

class _DeliveryMethod extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Delivery method',style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        ),
        const SizedBox(height: 10,),
        Expanded(
            child: ListView.separated(
              itemCount: 5,
                scrollDirection:Axis.horizontal,itemBuilder: (context,index){
                  return Center(
                    child: Container(
                      width: 100,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 25,
                            color: Colors.black.withOpacity(0.08)
                          )
                        ]
                      ),
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 20,);
            },
                )
        )
      ],
    );
  }
  
}

class _Payment extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment',style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),),
            InkWell(
              onTap: (){
                print('Change');
              },
              child: const Text('Change',style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w300
              ),),
            )
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Image.asset('assets/images/banner1.png',width: 100,height: 50,fit: BoxFit.fill,),
            const SizedBox(width: 10,),
            const Text('**** **** **** 3947',style: TextStyle(
              fontSize: 14
            ),)
          ],
        )
      ],
    );
  }

}

class _ShippingAddress extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shipping address',style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w200
        ),),
        const SizedBox(height: 10,),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 25,
                    color: Colors.black.withOpacity(0.08)
                )
              ]
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Name nguoi',style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200
                  ),),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, RoutesName.shippingAddressPage);
                    },
                    child: const Text('Change',style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w300
                    ),),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              const Text('Address',style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200
              ),),
              const Text('Address 2')
            ],
          ),
        )
      ],
    );
  }
}