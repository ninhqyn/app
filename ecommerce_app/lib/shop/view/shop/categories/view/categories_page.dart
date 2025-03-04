
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/view/shop/categories/view/list_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShopPageView();
  }
}

// Tạo một widget mới để chứa nội dung
class ShopPageView extends StatelessWidget {
  const ShopPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // List<Widget> widgetOption = [
    //   const WomenPage(),
    //   const ManPage(),
    //   const ChildrenPage()
    // ];

    return Column(
      children: [
        const SizedBox(height: 20),
        const ProductTabs(),
        Expanded(
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if (state is CategoriesLoadedState) {
                return SingleChildScrollView(
                  child: ListCategory(items: state.categories),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }
}


class ProductTabs extends StatefulWidget {
  const ProductTabs({super.key});

  @override
  State<ProductTabs> createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> {
  void handleSelectedTab(int index,int productId) {
    context.read<ShopBloc>().add(TabChanged(index,productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is CategoriesLoadedState) {
          return Row(
            children: List.generate(state.categoriesParent.length, (index) {
              return Expanded(
                child: InkWell(
                  onTap: () => handleSelectedTab(index,state.categoriesParent[index].categoryId),
                  child: Column(
                    children: [
                      Text(
                        state.categoriesParent[index].name,
                        style: state.tabIndex == index ? const TextStyle(
                        fontWeight: FontWeight.bold,
                          fontSize: 16
                      ):const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),),
                      const SizedBox(height: 8),
                      state.tabIndex == index
                          ? LinearProgressIndicator(
                        color: Colors.red,
                        value: 1.0,
                        backgroundColor: Colors.grey[200],
                        minHeight: 4,
                      )
                          : const LinearProgressIndicator(
                        value: 0.0,
                        backgroundColor: Colors.transparent,
                        minHeight: 4,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }
        return const SizedBox(); // Or some other loading widget
      },
    );
  }
}



