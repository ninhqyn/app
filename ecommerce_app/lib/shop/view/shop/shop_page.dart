import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/view/shop/categories/view/categories_page.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/product_list_page.dart';
import 'package:ecommerce_app/shop/view/shop/product_type/product_type_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopBloc>(
      create: (context) =>
      ShopBloc()
        ..add(LoadCategoriesEvent()),
      child: Builder(
        builder: (context) {
          // Sử dụng BlocBuilder bên trong Builder để đảm bảo context có thể truy cập Provider
          return const ShopView();
        },
      ),
    );
  }


}

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MyAppBar(),
        BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if (state is CategoriesLoadedState) {
                print(state.categories[0].name);
                return const Expanded(child: CategoriesPage());
              } else if (state is ProductTypeLoadedState) {
                return const Expanded(child: ProductTypePage());
              }
              else if (state is ProductLoadedState) {
                return const Expanded(child: ProductListPage());
              } else {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
            }),
      ],
    );
  }
}

class _MyAppBar extends StatelessWidget {
  const _MyAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 4)
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              print('navigator');
              context.read<ShopBloc>().add(NavigateBackEvent());
            },
            child: BlocBuilder<ShopBloc, ShopState>(
              builder: (context, state) {
                if(state is CategoriesLoadedState){
                  return Container();
                }
                return SvgPicture.asset(
                  'assets/images/back.svg',
                  width: 24,
                  height: 24,
                );
              },
            ),
          ),
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if (state is ProductLoadedState) {
                return Container();
              }
              return const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );
            },
          ),
          SvgPicture.asset(
            'assets/images/search.svg',
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}
