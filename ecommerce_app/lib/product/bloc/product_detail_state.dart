part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailState extends Equatable{}

final class ProductDetailInitial extends ProductDetailState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class LoadingState extends ProductDetailState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class LoadedProductState extends ProductDetailState{
  final ProductModel productModel;
  final List<ColorProduct> colors;
  final List<SizeProduct> sizes;
  final int sizeSelectedIndex;
  final int colorSelectedIndex;
  final ColorProduct? colorSelected;
  final SizeProduct? sizeSelected;
  LoadedProductState({
    required this.productModel,
    required this.colors,
    required this.sizes,
    this.sizeSelectedIndex = 0,
    this.colorSelectedIndex = 0,
    this.colorSelected,
    this.sizeSelected
  });
  // factory LoadedProductState.empty() {
  //   return LoadedProductState(
  //       productModel: Product.empty()
  //   );
  // }
  LoadedProductState copyWith({
    ProductModel? productModel,
    List<ColorProduct>? colors,
    List<SizeProduct>? sizes,
    int? sizeSelectedIndex,
    int? colorSelectedIndex,
    SizeProduct? sizeSelected,
    ColorProduct? colorSelected
}){
    return LoadedProductState(
      productModel: productModel ?? this.productModel,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      sizeSelectedIndex: sizeSelectedIndex ?? this.sizeSelectedIndex,
      colorSelectedIndex: colorSelectedIndex ?? this.colorSelectedIndex,
      sizeSelected: sizeSelected ?? this.sizeSelected,
      colorSelected: colorSelected ?? this.colorSelected
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [
    productModel,
    colors,
    sizes,
    sizeSelectedIndex,
    colorSelected,
    sizeSelected,
    colorSelectedIndex
  ];
}