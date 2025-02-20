import 'package:flutter/material.dart';

class ItemPromo extends StatelessWidget{
  const ItemPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 25,
            color: Colors.black.withOpacity(0.08)
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Image.asset('assets/images/banner1.png',fit: BoxFit.fill,),
          )),
          Expanded(
              flex:3,
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name promo',style: TextStyle(
                            fontSize:14,
                            fontWeight: FontWeight.w300
                          ),),
                          SizedBox(height: 10,),
                          Text('promo code',style: TextStyle(
                              fontSize:11,
                              fontWeight: FontWeight.w200
                          ),)
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('6 days remaining',style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey
                          ),),
                          const SizedBox(height: 5,),
                          ElevatedButton(onPressed: (){

                          },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(50, 50)
                              ),
                              child: const Text('Apply',style: TextStyle(
                            color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300
                          ),))
                        ],
                      ),
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}