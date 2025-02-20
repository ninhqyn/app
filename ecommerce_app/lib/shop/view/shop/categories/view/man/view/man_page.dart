
import 'package:flutter/material.dart';

import '../../../widgets/card_category_item.dart';
import '../../../widgets/card_sale.dart';

class ManPage extends StatelessWidget {
  const ManPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const CardSale(
              mainTitle: 'Man sale',
              extraTitle: 'Sale up to 80%',
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
        return const CardCategoryItemItem();
      },
    );
  }
}

