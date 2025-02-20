import 'package:flutter/material.dart';

class ShippingAddressPage extends StatelessWidget {
  const ShippingAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
      ),
      body: const ShippingAddressView(),
      floatingActionButton: Container(
        width: 36,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.22)
            )
          ]
        ),
        child: const Icon(Icons.add,color: Colors.white,),
      ),

    );
  }

}

class ShippingAddressView extends StatelessWidget{
  const ShippingAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top:25),
        child: ListView.separated(
            shrinkWrap: true,
            itemCount:5,
            itemBuilder: (context,index){
              return const CardItemAddress();
            }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 20,); },),
      ),
    );
  }
}

class CardItemAddress extends StatelessWidget{
  const CardItemAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
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
          const Text('Address',style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200
          ),),
          const Text('Address 2'),
          const SizedBox(height: 20,),
          Row(
            children: [
              Checkbox(value: false, onChanged: (value){
                print('on changed');
                value = true;
              }),
              const SizedBox(width: 5,),
              const Text('Use as the shipping address',style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200
              ),)
            ],
          )
        ],
      ),
    );
  }
}