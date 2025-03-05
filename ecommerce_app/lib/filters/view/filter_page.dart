import 'package:color_repository/color_repository.dart';
import 'package:ecommerce_app/favorites/bloc/favorites_bloc.dart';
import 'package:ecommerce_app/home/bloc/home_bloc.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:product_api/product_api.dart';
import 'package:product_repository/product_repository.dart';
import 'package:size_repository/size_repository.dart';

import '../../config/routes.dart';
import '../bloc/filter_bloc.dart';
import 'brand_screen.dart';
import 'filter_screen.dart';
class FilterPage extends StatelessWidget {
  const FilterPage({super.key, required this.page});
  final String page;
  @override
  Widget build(BuildContext context) {
    if(page == RoutesName.shopPages){
      return BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          if(state is ProductLoadedState){
            return BlocProvider<FilterBloc>(
              create: (context) =>
              FilterBloc(
                  context.read<ProductRepository>(),
                  context.read<SizeRepository>(),
                  context.read<ColorRepository>())..add(LoadedFilterScreen(state.filter)),
              child: Scaffold(
                body: const SafeArea(child: FilterView()
                ),
                bottomNavigationBar: _BottomNavigator(page: page,),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );

        },
      );
    }
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );

      },
    );

  }
}

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc,FilterState>(
  builder: (context, state) {
    final String title = state.navigatorBrand ? 'brand': 'filter';
    return Column(
      children: [
               Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            if(state.navigatorBrand){
                              context.read<FilterBloc>().add(NavigatorBack());
                            }
                            else{
                              Navigator.pop(context);
                            }
                          },
                          child: SvgPicture.asset('assets/images/back.svg')
                      ),
                      Text(title),
                      Container()
                    ],),
               ),
        Expanded(
          child: IndexedStack(
            index: state.navigatorBrand ? 1 : 0,
            children: const[
              FilterScreen(),
              BrandScreen(),
            ],),
        )
    ],
    );
  },
);
  }
}

class _BottomNavigator extends StatelessWidget {
  const _BottomNavigator({required this.page});
  final String page;

  @override
  Widget build(BuildContext context) {
    var widthButton = MediaQuery.of(context).size.width / 2 - 24; // Adjusted padding
    var heightButton = 36.0;
    return Container(
      height: 80, // Reduced height
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, -4),
                blurRadius: 8
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed to spaceBetween
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(widthButton, heightButton),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              side: const BorderSide(color: Colors.black26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {

            },
            child: const Text(
              'Discard',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(widthButton, heightButton),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
             final filterState = context.read<FilterBloc>().state;
             final filterModel = filterState.filterModel;
             if(page == RoutesName.shopPages){
               if(filterModel != null){
                 context.read<ShopBloc>().add(FilterChanged(filterModel));
                 print('filter model shop');
               }else{
                 context.read<ShopBloc>().add(FilterChanged(const FilterModel()));
                 print('filter model shop null');
               }
             }

             Navigator.pop(context);
            },
            child: const Text(
              'Apply',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

