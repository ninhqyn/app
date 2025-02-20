import 'package:ecommerce_app/app.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModalButton extends StatefulWidget {
  const ModalButton({super.key});

  @override
  _ModalButtonState createState() => _ModalButtonState();
}

class _ModalButtonState extends State<ModalButton> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ProductLoadedState) {
          // Cập nhật selectedIndex dựa trên sortType hiện tại
          _selectedIndex = switch(state.sortType) {
            SortType.popular => 0,
            SortType.newest => 1,
            SortType.customerReview => 2,
            SortType.lowToHigh => 3,
            SortType.highToLow => 4,
          };
        }

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: MediaQuery.of(context).size.height * 1 / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Sort by',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      _buildSortOption('Popular', 0),
                      _buildSortOption('Newest', 1),
                      _buildSortOption('Customer review', 2),
                      _buildSortOption('Price: lowest to high', 3),
                      _buildSortOption('Price: highest to low', 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String text, int index) {
    return GestureDetector(
      onTap: () {
        final newSortType = switch(index) {
          0 => SortType.popular,
          1 => SortType.newest,
          2 => SortType.customerReview,
          3 => SortType.lowToHigh,
          4 => SortType.highToLow,
          _ => SortType.popular,
        };

        context.read<ShopBloc>().add(SortChanged(newSortType));
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.red : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: _selectedIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}