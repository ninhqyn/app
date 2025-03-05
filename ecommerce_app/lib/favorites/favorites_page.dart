import 'package:flutter_svg/svg.dart';
import 'package:ecommerce_app/favorites/bloc/favorites_bloc.dart';
import 'package:ecommerce_app/favorites/widget/filter_control_favorites.dart';
import 'package:ecommerce_app/favorites/widget/item_grid.dart';
import 'package:ecommerce_app/favorites/widget/item_list.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_type_repository/product_type_repository.dart';


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritesView();
  }

}

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {

  Widget GridViewItem(FavoritesInitial state){
    return Padding(
      padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: state.productModels.length, // Số lượng item trong Grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            //mainAxisSpacing: 10,
            childAspectRatio: 0.75
        ),
        itemBuilder: (context, index) {
          if (index < state.productModels.length) {
            return InkWell(
              onTap: () {
                //onNavigatorDetailProduct(context,index);
              },
              child: CardGrid(
                productModel: state.productModels[index],
                onTap: () {
                  context.read<FavoritesBloc>().add(RemoveFavorite(state.productModels[index].product.productId));
                },
              ),
            );
          } else {
            return const SizedBox();}

        },
      ),
    );
  }
  Widget ListViewItem(FavoritesInitial state){
    return Padding(
        padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10
        ),
        child:ListView.separated(
          itemCount: state.productModels.length,
          itemBuilder: (context,index){
            return  ItemList(onTap: () {
              context.read<FavoritesBloc>().add(RemoveFavorite(state.productModels[index].product.productId));
            }, item: state.productModels[index],);
          }, separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 25,);
        },
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TitlePage(title: 'Favorites'),
        const _CategoryFilterSection(),
        const FilterControlFavorites(),
        Expanded(
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                if(state is FavoritesInitial){
                  if (state.productModels.isEmpty) {
                    return const Center(
                      child: Text('Không có sản phẩm yêu thích'),
                    );
                  }
                  if(state.modelType == ModelType.grid){
                    return GridViewItem(state);
                  }
                  if(state.modelType == ModelType.list){
                    return ListViewItem(state);
                  }
                }
                return const Center(
                  child: Text('Not found product'),
                );

              },
            )
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesBloc>().add(FetchDataProductFavorites());
    });
  }
}

class _CategoryFilterSection extends StatelessWidget {
  const _CategoryFilterSection();

  Widget NotFoundProduct() =>
      const Center(
        child: Text('Not found product favorites'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesInitial) {
          return Container(
            margin: const EdgeInsets.only(
                left: 10,
                bottom: 10
            ),
            height: 25,
            child: ListView
                .separated(
                shrinkWrap: true,
                itemCount: state.productType.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                const SizedBox(width: 10,),
                itemBuilder: (context, index) {
                  return InkWell(onTap: (){
                    context.read<FavoritesBloc>().add(FavoriteSelectProductType(state.productType[index]));
                  },child: _CategoryFilterItem(productType: state.productType[index],));
                }),
          );
        }
        return NotFoundProduct();
      },
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
class _TitlePage extends StatelessWidget {
  final String title;

  const _TitlePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(title, style: const TextStyle(
              color: Colors.black,
              fontSize: 34,
              fontWeight: FontWeight.bold
          ),),
          SvgPicture.asset('assets/images/search.svg')
        ],
      ),
    );
  }
}