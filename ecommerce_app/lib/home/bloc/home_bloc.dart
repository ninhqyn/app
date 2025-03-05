import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:product_api/product_api.dart';
import 'package:product_repository/product_repository.dart';

import '../../shop/models/product_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._productRepository) : super(HomeInitial()) {
    on<ProductFetched>(_onProductFetched);
  }
  final ProductRepository _productRepository;

  FutureOr<void> _onProductFetched(ProductFetched event, Emitter<HomeState> emit) async {
    emit(Loading());
    try {
      List<Product> products = await _productRepository.getAllProduct();
      List<Future<List<ProductImage>>> imageFutures = products.map((product) {
        return  _productRepository.getAllProductImage(product.productId);
      }).toList();

      // Chờ tất cả các API trả về cùng lúc
      List<List<ProductImage>> allImages = await Future.wait(imageFutures);
      List<ProductModel> productModels = [];
      for (int i = 0; i < products.length; i++) {
        productModels.add(ProductModel(
          product: products[i],
          productImages: allImages[i],
        ));
      }
      print('succes to fetch load to categoryModel');

      emit(LoadedProduct(productModels: productModels,status: StatusFetched.success));
    } catch(e) {
      emit(LoadedProduct(status: StatusFetched.failure));
    }
  }
}
