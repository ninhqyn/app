import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/product/bloc/product_detail_bloc.dart';

class ImageProduct extends StatelessWidget {
  const ImageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        if (state is LoadedProductState) {
          return Container(
            height: 1 / 1.5 * MediaQuery.of(context).size.height,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,  // Hiển thị danh sách ảnh nằm ngang
              itemCount: state.productModel.productImages.length,  // Số lượng ảnh trong productImages
              itemBuilder: (context, index) {
                final productImage = state.productModel.productImages.isNotEmpty
                    ? state.productModel.productImages[index].imageUrl
                    : ''; // Đảm bảo có ảnh hoặc giá trị mặc định
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Image.network(
                    productImage,
                    width: 2/3*MediaQuery.of(context).size.width, // Chiếm hết chiều rộng Container
                    height: double.infinity, // Chiều cao ảnh sẽ phù hợp với chiều cao của Container
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/image5.png', // Nếu lỗi, hiển thị ảnh mặc định
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width, // Chiếm hết chiều rộng
                        height: double.infinity, // Chiều cao ảnh sẽ phù hợp với chiều cao của Container
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        return SizedBox(
          height: 1 / 2 * MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
