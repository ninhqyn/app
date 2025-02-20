import 'package:flutter/material.dart';
import '../../../widgets/card_category_item.dart';
import '../../../widgets/card_sale.dart';

class ChildrenPage extends StatelessWidget {
  const ChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const CardSale(
              mainTitle: 'Children sale ',
              extraTitle: 'Up to 70% off',
            ),
            const SizedBox(height: 20,),
            const SizedBox(height: 20,),
            _ListItem()
          ],
        ),
      ),
    );
  }
}


class _ListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(  // Dùng ListView.separated thay vì ListView.builder
      shrinkWrap: true,  // Cho phép ListView co lại theo nội dung
      itemCount: 5,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: (){
              print('onSelected');
              //context.read<ShopBloc>().add(CategorySelected(const Category(1,'22')));
            },
            child: const CardCategoryItemItem()
        );
      },
    );
  }
}

