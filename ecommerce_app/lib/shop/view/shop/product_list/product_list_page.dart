import 'package:ecommerce_app/config/routes.dart';
import 'package:ecommerce_app/home/widgets/card_item.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/widgets/filter_control.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/widgets/product_item_grid_mode.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/widgets/product_item_list_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
class ProductListPage extends StatelessWidget{
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // Sử dụng BlocBuilder bên trong Builder để đảm bảo context có thể truy cập Provider
        return const ProductListView();
      },
    );
  }

}
class ProductListView extends StatelessWidget{
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitlePage(title:'Women\'s tops'),
        _CategoryFilterSection(),
        FilterControl(),
        _ListProduct()
      ],
    );
  }

}

class _ListProduct  extends StatelessWidget{
  const _ListProduct();

  @override
  Widget build(BuildContext context) {
    
    return Expanded(
        child:Container(
          color: Colors.grey.withOpacity(0.1),
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if(state is ProductLoadedState){
                if(state.modelType == ModelType.grid){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        return InkWell(onTap:(){
                          onNavigatorDetailProduct(context,index);
                        },
                            child: const ProductItemGridMode());
                      },
                    ),
                  );
                }
              }

    return ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.vertical,
              itemBuilder: (context,index){
                return InkWell(onTap:(){
                  onNavigatorDetailProduct(context, index);
                },child: const ProductItemListMode());
          }
          );
  },
),
        )
    );
  }
}

void onNavigatorDetailProduct(BuildContext  context,int index) {
  Navigator.pushNamed(context, RoutesName.productDetail,arguments: index);
}



class _CategoryFilterSection  extends StatelessWidget{
  const _CategoryFilterSection();

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        bottom: 10
      ),
      height: 25,
      child: ListView.separated(  // Dùng ListView.separated thay vì ListView.builder
          shrinkWrap: true,  // Cho phép ListView co lại theo nội dung
          itemCount: 20,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 10,),
          itemBuilder: (context, index){
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
         child: Text('abc',style: TextStyle(
           color: Colors.white,
           fontSize: 14
         ),),
       ));
  }

}

class _TitlePage extends StatelessWidget{
  final String title;
  const _TitlePage({required this.title});

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(10),
     child: Text(title,style: const TextStyle(
       color: Colors.black,
       fontSize:34,
       fontWeight: FontWeight.bold
     ),),
   );
  }
}