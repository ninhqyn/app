
import 'package:bloc/bloc.dart';
import 'package:color_repository/color_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:product_repository/product_repository.dart';
import 'package:size_repository/size_repository.dart';

import '../../shop/models/product_model.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc(
      this._productRepository,
      this._colorRepository,
      this._sizeRepository
      ) : super(ProductDetailInitial()) {
    on<FetchedProduct>(_onLoadedProduct);
    on<SelectSize>(_onSelectSize);
    on<SelectColor>(_onSelectColor);
  }
  final ProductRepository _productRepository;
  final ColorRepository _colorRepository;
  final SizeRepository _sizeRepository;

  void _onSelectSize(SelectSize event,Emitter<ProductDetailState> emit){
    if(state is LoadedProductState){
      final currentState = state as LoadedProductState;
      emit(currentState.copyWith(sizeSelectedIndex: event.index,sizeSelected: event.size));
    }

  }
  void _onSelectColor(SelectColor event,Emitter<ProductDetailState> emit){
    if(state is LoadedProductState){
      final currentState = state as LoadedProductState;
      emit(currentState.copyWith(colorSelectedIndex: event.index,colorSelected: event.color));
    }

  }
  Future<void> _onLoadedProduct(FetchedProduct event,Emitter<ProductDetailState> emit) async{
    emit(LoadingState());
    try{
      final product = await _productRepository.getProductById(event.productId);
      final productImages = await _productRepository.getAllProductImage(event.productId);
      final sizes = await _sizeRepository.getAllSizeByProductId(event.productId);
      final colors = await _colorRepository.getAllColorByProductId(event.productId);
      ProductModel productModel = ProductModel(product: product, productImages: productImages);
      emit(LoadedProductState(productModel: productModel,colors: colors,sizes: sizes,sizeSelected: sizes[0],colorSelected: colors[0]));
      print('success to fetch api product');
    }catch(e){
      print('failure to fetch api');
    }
  }
}
