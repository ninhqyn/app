import 'package:ecommerce_app/bag/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bag/bloc/check_out/check_out_bloc.dart';
import 'package:ecommerce_app/bag/bloc/shipping_address/shipping_address_bloc.dart';
import 'package:ecommerce_app/bag/view/order_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/routes.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key, required this.order});

  final double order;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  void initState() {
    super.initState();
    context.read<CheckOutBloc>().add(FetchDataOrder(widget.order));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckOutBloc, CheckOutState>(
  listener: (context, state) {

    if (state is OrderSuccessState) {
      context.read<CartBloc>().add(LoadedCart());
      Navigator.pushReplacementNamed(context, RoutesName.orderSuccessPage);

    }
  },
  child: Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Check out', style: TextStyle(
              fontWeight: FontWeight.bold
          ),),
        ),
      ),
      body: const CheckOutView(),
      bottomNavigationBar: _MyNavigator(),
    ),
);
  }


}

class _MyNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              onTap: () {
                //
                context.read<CheckOutBloc>().add(SubmitOrder());
              },
              child: const Center(
                child: Text('SUBMIT ORDER', style: TextStyle(
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

class CheckOutView extends StatelessWidget {
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

class _TotalInFor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckOutBloc,CheckOutState>(
      builder: (context, state) {
        if(state is CheckOutInitial){
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Item(title: 'Order', amount: state.order.toString()),
              _Item(title: 'Delivery', amount: state.deliveryPrice == null ? '0':'${state.deliveryPrice}' ),
              _Item(title: 'Summary', amount: state.total.toString())
            ],
          );
        }
        return const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Item(title: 'Order', amount: '0\$'),
            _Item(title: 'Delivery', amount: '0\$'),
            _Item(title: 'Summary', amount: '0\$')
          ],
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final String amount;

  const _Item({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(
            fontSize: 14,
            color: Colors.grey
        ),),
        Text(amount, style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),)
      ],
    );
  }
}

class _DeliveryMethod extends StatelessWidget {
  List<Widget> deliveryMethod =[
    SvgPicture.asset('assets/images/fedex.svg'),
    SvgPicture.asset('assets/images/usps.svg'),
    SvgPicture.asset('assets/images/dhl.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Delivery method', style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        ),
        const SizedBox(height: 10,),
        Expanded(
            child: ListView.separated(
              itemCount: deliveryMethod.length,
              scrollDirection: Axis.horizontal, itemBuilder: (context, index) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      deliveryMethod[index],
                      const SizedBox(height: 5,),
                      const Text('2-3 days',style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey
                      ),)
                    ],
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

class _Payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),),
            InkWell(
              onTap: () {
                print('Change');
              },
              child: const Text('Change', style: TextStyle(
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
            Container(width: 64,height: 38,
                decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 25,
                  color: Colors.black.withOpacity(0.08)
                )
              ]
            ),padding:const EdgeInsets.all(8)
                ,child: SvgPicture.asset('assets/images/mastercard.svg')),
            const SizedBox(width: 10,),
            const Text('**** **** **** 3947', style: TextStyle(
                fontSize: 14
            ),)
          ],
        )
      ],
    );
  }

}

class _ShippingAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shipping address', style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold
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
          child: BlocBuilder<CheckOutBloc, CheckOutState>(
            builder: (context, state) {
              if (state is CheckOutInitial && state.address != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.address!.receiverName, style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesName
                                .shippingAddressPage);
                          },
                          child: const Text('Change', style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w600
                          ),),
                        )
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Text('${state.address!.wardName}, '
                        '${state.address!.districtName}, '
                        '${state.address!.provinceName}, '
                        'VietNam', maxLines: 1, style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                    ),),
                    Text(state.address!.detailAddress, style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                    ),)
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
      ],
    );
  }
}