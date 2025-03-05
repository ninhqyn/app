import 'package:cart_repository/cart_repository.dart';
import 'package:ecommerce_app/bag/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bag/bloc/shipping_address/shipping_address_bloc.dart';
import 'package:ecommerce_app/bag/widget/modal_promo_code.dart';
import 'package:ecommerce_app/widgets/title_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/routes.dart';
class BagPage extends StatefulWidget{
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<CartBloc>().add(LoadedCart());
    });

  }
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
                    child: BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        if(state is CartInitial){
                          if(state.cartItems.isEmpty){
                            return InkWell(
                                onTap: () {
                                  // Show a Snackbar if the cart is empty
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select products first!'),
                                      backgroundColor: Colors.red,  // Optional: You can customize the Snackbar's appearance
                                      duration: Duration(seconds: 2),  // The Snackbar will be shown for 2 seconds
                                    ),
                                  );
                                },
                                child: const Center(
                                  child: Text(
                                    'CHECK OUT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ));
                          }
                          return InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, RoutesName.checkOutPage,arguments: state.totalAmount);
                            },
                            child: const Center(
                              child: Text('CHECK OUT',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          );
                        }
                        return InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, RoutesName.checkOutPage,arguments: 0);
                          },
                          child: const Center(
                            child: Text('CHECK OUT',style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        );
                      },
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total amount',style: TextStyle(
              color: Colors.black,
              fontSize: 15
          ),),
          BlocBuilder<CartBloc,CartState>(
  builder: (context, state) {
    double total = 0;
    if(state is CartInitial){
      total = state.totalAmount;
    }
    return Text( '$total d',style: const TextStyle(
              color: Colors.black,
              fontSize: 16,fontWeight: FontWeight.bold
          ),);
  },
),

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
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if(state is CartInitial){
          if(state.cartItems.isEmpty){
            return const Center(
              child: Text('Cart Item Empty \n Please Select product'),
            );
          }
          return ListView.separated(
              itemCount:state.cartItems.length,
              itemBuilder: (context,index){
                return InkWell(onTap: (){
                  Navigator.pushNamed(context, RoutesName.productDetail,arguments: state.cartItems[index].productId);
                },child: CardItemBag(item:state.cartItems[index]));
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 15)
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

}

class CardItemBag extends StatelessWidget{
  const CardItemBag({super.key, required this.item});
  final CartResponse item;
  void incrementAdd(BuildContext context,int itemId,int currentQuantity){
    context.read<CartBloc>().add(UpdateQuantity(itemId:  itemId,currentQuantity: currentQuantity,add: true));
  }
  void incrementMinus(BuildContext context,int itemId,int currentQuantity){
    context.read<CartBloc>().add(UpdateQuantity(itemId:  itemId,currentQuantity: currentQuantity,add: false));
  }
  void _showPopupMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx, // X
        position.dy, // Y
        position.dx + button.size.width, // Right
        position.dy + button.size.height, // Bottom
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 1,
          child: Text('Option 1'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('Option 2'),
        ),
        PopupMenuItem(
          value: 3,
          child: Text('Option 3'),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        // Xử lý giá trị khi người dùng chọn một mục
        print('Selected value: $value');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 104,
      decoration: BoxDecoration(
        boxShadow:[
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 1)
          ),
        ] ,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8)
              ),
              child: Image.network(
                item.imageUrlPrimay,fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/image5.png', // Ảnh mặc định trong assets
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),

            ),
          ),Expanded(
              flex:2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  bottom: 8
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.productName,style: const TextStyle(
                          fontSize:16,
                          fontWeight: FontWeight.bold
                        ),),
                        InkWell(onTap: (){
                          _showPopupMenu(context);
                        },child: SvgPicture.asset('assets/images/more.svg'))
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Color: ',style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11
                        ),),
                        Text(item.colorName,style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold
                        ),),
                        const SizedBox(width: 20,),
                        const Text('Size:',style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11
                        ),),
                        Text(item.sizeName,style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold
                        ),),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            InkWell(onTap: (){
                              incrementMinus(context,item.cartItemId,item.quantity);
                            },child: _IncrementButton(icon: SvgPicture.asset('assets/images/minus.svg'))),
                            const SizedBox(width: 10,),
                            Text(item.quantity.toString(),style: const TextStyle(
                              fontSize: 14
                            ),),
                            const SizedBox(width: 10,),
                            InkWell(onTap: (){
                              incrementAdd(context,item.cartItemId,item.quantity);
                            }, child: const _IncrementButton(
                              icon: Icon(Icons.add,color: Colors.grey,),))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text('${item.quantity * item.basePrice} d',style: const TextStyle(
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
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8
          )
        ]
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}