import 'package:ecommerce_app/favorites/widget/item_grid.dart';
import 'package:ecommerce_app/favorites/widget/item_list.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CardGrid(),
    );
  }

}