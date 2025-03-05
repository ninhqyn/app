
import 'package:category_repository/category_repository.dart';
import 'package:flutter/material.dart';
import '../widgets/card_category_item.dart';
import '../widgets/card_sale.dart';

class ListCategory extends StatelessWidget {
  const ListCategory({super.key, required this.items});
  final List<Category> items;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const CardSale(
              mainTitle: 'Summer Sale',
              extraTitle: 'Up to 50% off',
            ),
            const SizedBox(height: 20,),
            const SizedBox(height: 20,),
            _ListItem(items: items)
          ],
        ),
      ),
    );
  }
}


class _ListItem extends StatelessWidget {
  final List<Category> items;

  const _ListItem({super.key, required this.items});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return CardCategoryItemItem(category:items[index]);
      },
    );
  }
}

