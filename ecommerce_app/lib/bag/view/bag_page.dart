import 'package:ecommerce_app/bag/widget/modal_promo_code.dart';
import 'package:ecommerce_app/widgets/title_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class BagPage extends StatelessWidget{
  const BagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitlePage(title: 'My Bag'),
        Expanded(flex: 3,child: _MyListBag()),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(child: _PromoCodeButton()),
              Expanded(child: _TotalAmount()),
              Expanded(flex:2,child: Center(
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
                    child: const Center(
                      child: Text('CHECK OUT',style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ),
              ))
            ],
          ),
        )

      ],
    );
  }

}

class _TotalAmount extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total amount:',style: TextStyle(
              color: Colors.grey,
              fontSize: 11
          ),),
          Text('124\$',style: TextStyle(
              color: Colors.black,
              fontSize: 15
          ),),

        ],
      ),
    );
  }

}

class _PromoCodeButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(onTap:(){
        showModalBottomSheet(context: context, builder: (_){
          return const ModalPromoCode();
        });
      },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.05)
              ),

            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          //margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('   Enter your promo code',style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11
              ),),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle
                ),
                child: Center(child: SvgPicture.asset('assets/images/next.svg',color: Colors.white,)),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class _MyListBag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount:5,
      itemBuilder: (context,index){
      return const CardItemBag();
    }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 15,); },);
  }

}

class CardItemBag extends StatelessWidget{
  const CardItemBag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 104,
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8)
                ),
                child: Image.asset('assets/images/banner1.png',fit: BoxFit.fill,),

              ),
            ),Expanded(
                flex:2,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pullover',style: TextStyle(
                            fontSize:16,
                            fontWeight: FontWeight.bold
                          ),),
                          SvgPicture.asset('assets/images/more.svg')
                        ],
                      ),
                      const Row(
                        children: [
                          Text('Color: ',style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11
                          ),),
                          Text('Blue',style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: 20,),
                          Text('Color:',style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11
                          ),),
                          Text('Blue',style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold
                          ),),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _IncrementButton(icon: SvgPicture.asset('assets/images/minus.svg')),
                              const SizedBox(width: 10,),
                              const Text('1',style: TextStyle(
                                fontSize: 14
                              ),),
                              const SizedBox(width: 10,),
                              const _IncrementButton(icon: Icon(Icons.add,color: Colors.grey,),)
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Text('51\$',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class _IncrementButton  extends StatelessWidget{
   final Widget icon;

   const _IncrementButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            offset: const Offset(1, 1)
          )
        ]
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}