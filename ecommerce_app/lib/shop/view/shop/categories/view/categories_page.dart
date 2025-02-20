
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/view/shop/categories/view/women/view/women_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'children/view/children_page.dart';
import 'man/view/man_page.dart';

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
    List<Widget> widgetOption = [
      const WomenPage(),
      const ManPage(),
      const ChildrenPage()
    ];

    return Column(
      children: [
        const SizedBox(height: 20),
        const ProductTabs(),
        Expanded(
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if (state is CategoriesLoadedState) {
                return SingleChildScrollView(
                  child: widgetOption[state.tabIndex],
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
  void handleSelectedTab(int index) {
    context.read<ShopBloc>().add(TabChanged(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is CategoriesLoadedState) {
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => handleSelectedTab(0),
                  child: Column(
                    children: [
                      const Text('Women'),
                      const SizedBox(height: 8),
                      state.tabIndex == 0
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
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => handleSelectedTab(1),
                  child: Column(
                    children: [
                      const Text('Men'),
                      const SizedBox(height: 8),
                      state.tabIndex == 1
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
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => handleSelectedTab(2),
                  child: Column(
                    children: [
                      const Text('Children'),
                      const SizedBox(height: 8),
                      state.tabIndex == 2
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox(); // Hoặc một widget loading khác
      },
    );
  }
}



