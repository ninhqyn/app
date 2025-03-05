import 'package:ecommerce_app/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/order_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '  My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildTab(context, 'Delivered', 0),
              const SizedBox(width: 12),
              _buildTab(context, 'Processing', 1),
              const SizedBox(width: 12),
              _buildTab(context, 'Cancelled', 2),
            ],
          ),
        ),
        BlocBuilder<ProfileBloc,ProfileState>(
          builder: (context, state) {
            if(state is MyOrder){
              return Expanded(
                child: ListView.builder(
                  itemCount: state.orders.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int index) {
                    return OrderCard(item: state.orders[index],);
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
          context.read<ProfileBloc>().add(OrderTabSelect(index));
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
