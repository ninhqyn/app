import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:ecommerce_app/shop/view/filters/bloc/filter_bloc.dart';
import 'package:ecommerce_app/shop/view/filters/view/brand_screen.dart';
import 'package:ecommerce_app/shop/view/filters/view/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/brand.dart';
class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final ShopBloc shopBloc = ModalRoute.of(context)!.settings.arguments as ShopBloc;

    return BlocProvider<FilterBloc>(
        create: (context) =>
            FilterBloc(),
      child: const Scaffold(
        body: SafeArea(child: FilterView()
        ),
        bottomNavigationBar: _BottomNavigator(),
      ),
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
  const _BottomNavigator();

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
             print('apply filter');
             final filterState = context.read<FilterBloc>().state;
             final filterModel = filterState.filterModel;
             if(filterModel != null){
               context.read<ShopBloc>().add(FilterChanged(filterModel));
             }else{
               context.read<ShopBloc>().add(FilterChanged(const FilterModel()));
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

