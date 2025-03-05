
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTypePage extends StatelessWidget {
  const ProductTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  color: const Color(0xFFDB3022),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 2
                    )
                  ]
              ),
              child: const Center(
                child: Text('VIEW ALL ITEM', style: TextStyle(
                    color: Colors.white
                ),),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Choose category', style: TextStyle(
                color: Colors.grey,
                fontSize: 14
            ),
            ),
          ),
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if(state is ProductTypeLoadedState){
                return ListView.builder(
                    itemCount:state.productTypes.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          context.read<ShopBloc>().add(SelectProductTypeEvent(state.productTypes[index],state.categoryId));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              child: Text(
                                 state.productTypes[index].name, style: const TextStyle(
                                  fontSize: 16,fontWeight: FontWeight.bold
                              ),),
                            ),
                            LinearProgressIndicator(
                                minHeight: 1,
                                value: 100,
                                color: const Color(0xFF9B9B9B).withOpacity(0.4)
                            )
                          ],
                        ),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );

            },
          )
        ],
      ),
    );
  }

}