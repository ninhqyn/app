import 'package:ecommerce_app/favorites/bloc/favorites_bloc.dart';
import 'package:ecommerce_app/favorites/widget/filter_control_favorites.dart';
import 'package:ecommerce_app/favorites/widget/item_grid.dart';
import 'package:ecommerce_app/favorites/widget/item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitlePage(title: 'Favorites'),
          _CategoryFilterSection(),
          FilterControlFavorites(),
          Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 20, // Số lượng item trong Grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Số cột
                    crossAxisSpacing: 10, // Khoảng cách giữa các cột
                    //mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                    childAspectRatio: 0.75
                ),
                itemBuilder: (context, index) {
                  return InkWell(onTap: () {
                    //onNavigatorDetailProduct(context,index);
                  }, //
                      child: const CardGrid());
                },
              )
          )
        ],
      ),
    );
  }

}

class _CategoryFilterSection extends StatelessWidget {
  const _CategoryFilterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: 10,
          bottom: 10
      ),
      height: 25,
      child: ListView
          .separated( // Dùng ListView.separated thay vì ListView.builder
          shrinkWrap: true,
          // Cho phép ListView co lại theo nội dung
          itemCount: 20,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 10,),
          itemBuilder: (context, index) {
            return _CategoryFilterItem();
          }),
    );
  }
}

class _CategoryFilterItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(29)
        ),
        child: const Center(
          child: Text('abc', style: TextStyle(
              color: Colors.white,
              fontSize: 14
          ),),
        ));
  }

}

class _TitlePage extends StatelessWidget {
  final String title;

  const _TitlePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(title, style: const TextStyle(
          color: Colors.black,
          fontSize: 34,
          fontWeight: FontWeight.bold
      ),),
    );
  }
}