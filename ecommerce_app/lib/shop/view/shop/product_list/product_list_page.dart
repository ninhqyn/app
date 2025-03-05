import 'package:ecommerce_app/config/routes.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/widgets/filter_control.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/widgets/product_item_grid_mode.dart';
import 'package:ecommerce_app/shop/view/shop/product_list/widgets/product_item_list_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_type_repository/product_type_repository.dart';

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
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<ShopBloc, ShopState>(
          builder: (context, state) {
            if (state is ProductLoadedState) {
              // Kiểm tra nếu modelType là list
              if (state.modelType == ModelType.list) {
                return _TitlePage(title: state.productType.name.toString());
              }

              return const SizedBox(height: 10,);
            }

            // Trường hợp khi state không phải là ProductLoadedState
            return const _TitlePage(title: 'Empty');
          },
        ),

        const _CategoryFilterSection(),
        const FilterControl(),
        const _ListProduct()
      ],
    );
  }

}

class _ListProduct  extends StatelessWidget{
  const _ListProduct();

  Widget ItemNotFound(){
    return const Center(
      child: Text(
        'Not found Product',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:BlocBuilder<ShopBloc, ShopState>(
          builder: (context, state) {
            if(state is ProductLoadedState){
              if(state.productModels.isNotEmpty){
                return Container(
                  color: Colors.grey.withOpacity(0.1),
                  child: BlocBuilder<ShopBloc, ShopState>(
                    builder: (context, state) {
                      if(state is ProductLoadedState){
                        if(state.modelType == ModelType.grid){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount:state.productModels.length, // Số lượng item trong Grid
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Số cột
                                  crossAxisSpacing: 10, // Khoảng cách giữa các cột
                                  //mainAxisSpacing: 10, // Khoảng cách giữa các hàng
                                  childAspectRatio: 0.75
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(onTap:(){
                                  onNavigatorDetailProduct(context,state.productModels[index].product.productId);
                                },
                                    child: ProductItemGridMode(productModel:state.productModels[index]));
                              },
                            ),
                          );
                        }
                        return ListView.builder(
                            itemCount: state.productModels.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context,index){
                              return InkWell(onTap:(){
                                onNavigatorDetailProduct(context, state.productModels[index].product.productId);
                              },child:  ProductItemListMode(productModel:state.productModels[index]));
                            }
                        );

                      }return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                );
              }
            }
            return ItemNotFound();
          },
        )
    );
  }
}

void onNavigatorDetailProduct(BuildContext  context,int productId) {
  Navigator.pushNamed(context, RoutesName.productDetail,arguments: productId);
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
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          if(state is ProductLoadedState){
            return ListView.separated(
                shrinkWrap: true,
                itemCount: state.productTypes.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 10,),
                itemBuilder: (context, index){
                  return InkWell(onTap: (){
                    print("select");
                    context.read<ShopBloc>().add(SelectProductTypeInList(state.productTypes[index]));
                  },child: _CategoryFilterItem(productType: state.productTypes[index],));
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );

  }
}

class _CategoryFilterItem extends StatelessWidget {
  final ProductType productType;

  const _CategoryFilterItem({required this.productType});

  @override
  Widget build(BuildContext context) {
   return Container(
       padding: const EdgeInsets.symmetric(horizontal: 25),
       decoration: BoxDecoration(
         color: Colors.black,
         borderRadius: BorderRadius.circular(29)
   ),
       child: Center(
         child: Text(productType.name,style: const TextStyle(
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