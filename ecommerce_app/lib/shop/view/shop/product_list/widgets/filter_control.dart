
import 'package:ecommerce_app/config/routes.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import '../../../../../filters/view/filter_page.dart';
import 'modal_button.dart';

class FilterControl extends StatelessWidget {
  const FilterControl({super.key});

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

            // onTap: (){
            //   final shopBloc = context.read<ShopBloc>();
            //   Navigator.pushNamed(context, RoutesName.filterPage,arguments: shopBloc);
            // },
            onTap: (){
              final shopBloc = context.read<ShopBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider.value(
                      value: shopBloc,  // Truyền ShopBloc đã có sẵn
                      child: const FilterPage(page: RoutesName.shopPages,),
                    );
                  },
                ),
              );

            },
            child: Row(
              children: [
                SvgPicture.asset('assets/images/filter.svg'),
                const SizedBox(width: 5,),
                const Text('Filters')
              ],
            ),
          ),
          InkWell(
            onTap: () {
              final shopBloc = context.read<ShopBloc>();
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20))
                  ),
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                      value:shopBloc,
                      child: const ModalButton(),
                    );
                  });
            },
            child: Row(
              children: [
                SvgPicture.asset('assets/images/swap.svg'),
                const SizedBox(width: 5,),
                BlocSelector<ShopBloc, ShopState, SortType>(
                  selector: (state) {
                    // Only cast to ProductLoadedState if the state is of this type
                    if (state is ProductLoadedState) {
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
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              state as ProductLoadedState;
              final currentType = state.modelType;
              return InkWell(
                onTap: () {
                    final newType = currentType == ModelType.grid ? ModelType.list : ModelType.grid;
                    context.read<ShopBloc>().add(ModelChanged(newType));
                  },
                    child:  SvgPicture.asset(
                      currentType == ModelType.list
                          ? 'assets/images/grid_mode.svg' // Icon grid để chuyển sang dạng grid
                          : 'assets/images/list_mode.svg', // Icon list để chuyển sang dạng list
                    )
              );
            },
          )

          //Model Change

        ],
      ),
    );
  }
}
