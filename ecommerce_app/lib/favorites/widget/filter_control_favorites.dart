
import 'package:ecommerce_app/config/routes.dart';
import 'package:ecommerce_app/favorites/bloc/favorites_bloc.dart';
import 'package:ecommerce_app/favorites/widget/modal_button_favorites.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import '../../filters/view/filter_page.dart';

class FilterControlFavorites extends StatelessWidget {
  const FilterControlFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 5
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          InkWell(
            onTap: () {
            },
            child: InkWell(
                onTap: () {
                  final favoriteBloc = context.read<FavoritesBloc>();
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20))
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider.value(
                          value:favoriteBloc,
                          child: const ModalButtonFavorites(),
                        );
                      });
                },
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/swap.svg'),
                  const SizedBox(width: 5,),
                  BlocSelector<FavoritesBloc, FavoritesState, SortType>(
                    selector: (state) {
                      // Only cast to ProductLoadedState if the state is of this type
                      if (state is FavoritesInitial) {
                        return state.sortType;
                      } else {
                        return SortType.lowToHigh;  // Default value or handle error state
                      }
                    },
                    builder: (context, sortType) {
                      late String text;
                      switch (sortType) {
                        case SortType.highToLow:
                          text = 'Price: Highest to low';
                          break;
                        case SortType.lowToHigh:
                          text = 'Price: Lowest to high';
                          break;
                        case SortType.newest:
                          text = 'Newest';
                          break;
                        case SortType.popular:
                          text = 'Popular';
                          break;
                        case SortType.customerReview:
                          text = 'Customer Review';
                          break;
                        default:
                          text = "error";
                      }
                      return Text(
                        text,
                        style: const TextStyle(fontSize: 11),
                      );
                    },
                  )

                ],
              ),
            ),
          ),
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if(state is FavoritesInitial){
                final currentType = state.modelType;
                return InkWell(
                    onTap: () {
                      final newType = currentType == ModelType.grid ? ModelType.list : ModelType.grid;
                      context.read<FavoritesBloc>().add(FavoriteModelChanged(newType));
                    },
                    child:  SvgPicture.asset(
                      currentType == ModelType.list
                          ? 'assets/images/grid_mode.svg'
                          : 'assets/images/list_mode.svg',
                    )
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )

          //Model Change

        ],
      ),
    );
  }
}
