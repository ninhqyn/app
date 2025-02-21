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
              child:  const CategorySelector(),
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
class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    List<Category> categories =[
      Category(1, 'ALL'),
      Category(2, 'categories 2'),
      Category(3, 'categories 3'),
      Category(4, 'categories 4'),
      Category(5, 'categories 5'),
      Category(6, 'categories 6'),
    ];
    return  GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 cột
          crossAxisSpacing: 10, // Khoảng cách giữa các cột
          mainAxisSpacing: 10, // Khoảng cách giữa các hàng
          childAspectRatio: 3/1
      ),
      itemCount: categories.length, // Số lượng item trong Grid
      itemBuilder: (context, index) {
        return BlocBuilder<FilterBloc, FilterState>(
  builder: (context, state) {
    final isSelect = state.filterModel?.category?.id== categories[index].id;
    return InkWell(
          onTap: (){
            context.read<FilterBloc>().add(SelectCategory(categories[index]));
          },
          child: Container(
            decoration: BoxDecoration(
                color: isSelect ? Colors.red :Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                color: isSelect ? Colors.transparent : Colors.grey
                )
            ),
            child: Center(
              child: Text(
                categories[index].name,
                style: TextStyle(color: isSelect ?Colors.white : Colors.black),
              ),
            ),
          ),
        );
  },
);
      },
    );
  }
}
class SizeSelector extends StatelessWidget{
  const SizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SizeProduct> sizes = [
     SizeProduct.M,SizeProduct.S,SizeProduct.L,
      SizeProduct.xL,SizeProduct.xxL
    ];
    return ListView.separated(
      itemCount: sizes.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context , index){
        late String size;
        switch(sizes[index]){
          case SizeProduct.L:
            size = 'L';
          case SizeProduct.M:
            size = 'M';
          case SizeProduct.S:
            size = 'S';
          case SizeProduct.xL:
            size = 'XL';
          case SizeProduct.xxL:
            size = 'XXL';
          default:
            size = 'unKnow';
        }
        return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        final isSelected =
            state.filterModel?.sizes?.contains(sizes[index]) ?? false;
    return InkWell(
          onTap: (){
            if (isSelected) {
              context.read<FilterBloc>().add(DeselectSize(sizes[index]));
            } else {
              context.read<FilterBloc>().add(SelectSize(sizes[index]));
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
              child: Text(size,style:  TextStyle(
                  fontSize: 14,
                color: isSelected ? Colors.white : Colors.black
              ),),
            )

                        ),
          ),
        );
  },
);
      }, separatorBuilder: (BuildContext context, int index) {
      return const SizedBox(width: 20,);
    },);
  }

}
class ColorSelector extends StatelessWidget {
  ColorSelector({super.key});
  final List<Color> colors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.grey[400]!,
    const Color(0xFFDEB887),
    //Colors.navy,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: colors.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context , index){
        return BlocBuilder<FilterBloc, FilterState>(
  builder: (context, state) {
    final isSelect = state.filterModel?.colors?.contains(colors[index]) ?? false;
    return InkWell(
      onTap: (){
        if(isSelect){
          context.read<FilterBloc>().add(DeselectColor(colors[index]));
        }else{
          context.read<FilterBloc>().add(SelectColor(colors[index]));
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
                  color: colors[index],
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
  },
);
      }, separatorBuilder: (BuildContext context, int index) {
      return const SizedBox(width: 20,);
    },);
  }
}