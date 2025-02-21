import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shop/models/brand.dart';
import '../bloc/filter_bloc.dart';
class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Brand> list = [
      Brand(1, 'brand a'),
      Brand(2, 'brand b'),
      Brand(3, 'brand c'),
      Brand(4, 'brand d'),
      Brand(5, 'brand e'),
      Brand(6, 'brand f'),
    ];

    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: BlocBuilder<FilterBloc, FilterState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final isSelected =
                          state.filterModel?.brands?.contains(list[index]) ??
                              false;
                      return _ItemBrand(
                        brand: list[index],
                        isSelected: isSelected,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _ItemBrand extends StatelessWidget {
  const _ItemBrand({required this.brand, required this.isSelected});

  final Brand brand;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            brand.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: isSelected ? Colors.red : Colors.black, // Red when selected
            ),
          ),
          IconButton(
            icon: Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? Colors.red : Colors.grey, // Red when selected
            ),
            onPressed: () {
              // Dispatch an event to select or deselect the brand
              if (isSelected) {
                context.read<FilterBloc>().add(DeselectBrand(brand));
              } else {
                context.read<FilterBloc>().add(SelectBrand(brand));
              }
            },
          ),
        ],
      ),
    );
  }
}
