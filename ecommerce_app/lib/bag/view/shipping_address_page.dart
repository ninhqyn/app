import 'package:address_repository/address_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/bag/bloc/check_out/check_out_bloc.dart';
import 'package:ecommerce_app/bag/bloc/form_address/form_address_bloc.dart';
import 'package:ecommerce_app/bag/bloc/shipping_address/shipping_address_bloc.dart';
import 'package:ecommerce_app/bag/view/form_address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vn_repository/vn_repository.dart';


class ShippingAddressPage extends StatelessWidget {
  const ShippingAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShippingAddressBloc, ShippingAddressState>(
  listener: (context, state) {
    if(state is DefaultAddressSuccess){
      context.read<CheckOutBloc>().add(ChangedAddressShipping());
    }
  },
  child: Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
      ),
      body: const ShippingAddressView(),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => BlocProvider(
            create: (context) => FormAddressBloc(
              addressRepository: context.read<AddressRepository>(),
              authenticationRepository: context.read<AuthenticationRepository>(),
              vnRepository: context.read<VnRepository>()
            )..add(LoadedFormAddress()),
            child: const FormAddressPage(isEditing: false,),
          ),
          ),);
        },
        child: Container(
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
          child: const Icon(Icons.add, color: Colors.white,),
        ),
      ),

    ),
);
  }

}

class ShippingAddressView extends StatefulWidget {
  const ShippingAddressView({super.key});

  @override
  State<ShippingAddressView> createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: BlocBuilder<ShippingAddressBloc, ShippingAddressState>(
          builder: (context, state) {
            if(state is ShippingAddressInitial){
              return ListView.separated(
                shrinkWrap: true,
                itemCount: state.address.length,
                itemBuilder: (context, index) {
                  return CardItemAddress(item:state.address[index]);
                }, separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20,);
              },);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );

          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ShippingAddressBloc>().add(FetchAddress());
  }
}

class CardItemAddress extends StatelessWidget {
  const CardItemAddress({super.key, required this.item});
  final Address item;
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
              Text(item.receiverName, style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => FormAddressBloc(
                            addressRepository: context.read<AddressRepository>(),
                            authenticationRepository: context.read<AuthenticationRepository>(),
                            vnRepository: context.read<VnRepository>(),
                            initialAddress: item,
                            isEditing: true
                        )..add(LoadedFormAddress()),
                        child: const FormAddressPage(isEditing: true,),
                      ),
                    ),);
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
          Text(item.detailAddress, style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400
          ),),
          Text('${item.wardName},${item.districtName},${item.provinceName} ',style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400
          ),),
          const SizedBox(height: 20,),
          Row(
            children: [
              Checkbox(value: item.isDefault, onChanged: (value) {
                print('on changed');
                context.read<ShippingAddressBloc>().add(UseDefaultAddress(item));
              }),
              const SizedBox(width: 5,),
              const Text('Use as the shipping address', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300
              ),)
            ],
          )
        ],
      ),
    );
  }
}