import 'package:category_repository/category_repository.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/view/shop/categories/view/categories_page.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/product_list_page.dart';
import 'package:ecommerce_app/shop/view/shop/product_type/product_type_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:product_repository/product_repository.dart';
import 'package:product_type_repository/product_type_repository.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopBloc>(
      create: (context) =>
      ShopBloc(
          context.read<CategoryRepository>(),
          context.read<ProductTypeRepository>(),
          context.read<ProductRepository>())
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
        // BlocBuilder<ShopBloc, ShopState>(
        //     builder: (context, state) {
        //       if (state is CategoriesLoadedState) {
        //         print(state.categories[0].name);
        //         return const Expanded(child: CategoriesPage());
        //       } else if (state is ProductTypeLoadedState) {
        //         return const Expanded(child: ProductTypePage());
        //       }
        //       else if (state is ProductLoadedState) {
        //         return const Expanded(child: ProductListPage());
        //       } else {
        //         return const Expanded(
        //             child: Center(child: CircularProgressIndicator()));
        //       }
        //     }),
        BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              int selectedIndex = 0; // Mặc định là trang đầu tiên (Categories)
              if (state is CategoriesLoadedState) {
                selectedIndex = 0; // Chọn trang Categories
              } else if (state is ProductTypeLoadedState) {
                selectedIndex = 1; // Chọn trang Product Type
              } else if (state is ProductLoadedState) {
                selectedIndex = 2; // Chọn trang Product List
              }
              return Expanded(
                child: IndexedStack(
                  index: selectedIndex,  // Dùng index để chọn trang hiện tại
                  children: const [
                    CategoriesPage(),   // Trang Categories
                    ProductTypePage(),  // Trang Product Type
                    ProductListPage(),  // Trang Product List
                  ],
                ),
              );})

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
                if (state is CategoriesLoadedState) {
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
                if(state.modelType == ModelType.list){
                  return Container();
                }else{
                  return Text(
                    state.productType.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                }

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
