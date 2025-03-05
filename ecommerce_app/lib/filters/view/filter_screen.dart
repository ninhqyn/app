import 'package:ecommerce_app/shop/models/category.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/filter_bloc.dart';
class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var currentStart = 0.0;
  var currentEnd = 100.0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Price range'),
            _rangePrice(context),
            const Text('Colors'),
            Container(
              height: 100,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10),
              child:  ColorSelector(),
            ),
            const Text('Size'),
            Container(
              height: 100,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10),
              child:  const SizeSelector(),
            ),
            const Text('Categories'),
            Container(
              height: 160,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child:  Center(
                child: Text('category'),
              ),
            ),
            const Text('Brand'),
            InkWell(
              onTap: (){
                context.read<FilterBloc>().add(NavigatorBrand());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('adidas Originals, Jack & Jones, s.Oliver',
                    style:
                    TextStyle(
                        color: Colors.grey,
                        fontSize: 11
                    ),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/images/baseline-keyboard_arrow_right-24px.svg'),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
  Widget _rangePrice(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        // Khởi tạo giá trị từ state hoặc dùng giá trị mặc định
        currentStart = state.filterModel?.startRange?.toDouble() ?? currentStart;
        currentEnd = state.filterModel?.endRange?.toDouble() ?? currentEnd;

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${currentStart.toStringAsFixed(1)} \$'),
                  Text('${currentEnd.toStringAsFixed(1)} \$'),
                ],
              ),
              RangeSlider(
                min: 0.0,
                max: 100.0,
                inactiveColor: const Color(0xFF9B9B9B),
                activeColor: Colors.red,
                values: RangeValues(currentStart, currentEnd),
                onChanged: (RangeValues values) {
                  setState(() {
                    currentStart = values.start;
                    currentEnd = values.end;
                  });
                  context.read<FilterBloc>().add(
                      SelectPrice(currentStart.toInt(), currentEnd.toInt()));
                },
              )
            ],
          ),
        );
      },
    );

  }
}

class SizeSelector extends StatelessWidget{
  const SizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.sizes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context , index){
            final isSelected =
                state.filterModel?.sizes?.contains(state.sizes[index]) ?? false;
            return InkWell(
                onTap: (){
                  if (isSelected) {
                    context.read<FilterBloc>().add(DeselectSize(state.sizes[index]));
                  } else {
                    context.read<FilterBloc>().add(SelectSize(state.sizes[index]));
                  }
                },
                child: Center(
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: isSelected ?Colors.red:Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                          )
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Text(state.sizes[index].name,style:  TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.black
                        ),),
                      )

                  ),

                )
            );
          }, separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 20,);
        },);
      },
    );
  }

}
class ColorSelector extends StatelessWidget {
  const ColorSelector({super.key});

  Color hexToColor(String hex) {
    // Loại bỏ ký tự '#' nếu có
    hex = hex.replaceAll('#', '');
    // Kiểm tra và chuyển chuỗi hex thành một đối tượng Color
    return Color(int.parse('0xFF' + hex)); // '0xFF' là mã alpha cho màu không trong suốt
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
  builder: (context, state) {
    return ListView.separated(
      itemCount: state.colors.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context , index){
    final isSelect = state.filterModel?.colors?.contains(state.colors[index]) ?? false;
    return InkWell(
      onTap: (){
        if(isSelect){
          context.read<FilterBloc>().add(DeselectColor(state.colors[index]));
        }else{
          context.read<FilterBloc>().add(SelectColor(state.colors[index]));
        }
      },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelect ?Colors.red:Colors.transparent,
                )
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                  color: hexToColor(state.colors[index].colorCode),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1)
                    )
                  ]
              ),
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) {
      return const SizedBox(width: 20,);
    },);
  },
);
  }
}