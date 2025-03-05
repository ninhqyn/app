part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesState extends Equatable{}

final class FavoritesInitial extends FavoritesState {
  final List<ProductModel> productModels;
  final ModelType modelType;
  final SortType sortType;
  final List<ProductType> productType;
  final int productTypeId;
  FavoritesInitial({
    this.productModels = const<ProductModel>[],
    this.modelType = ModelType.list,
    this.sortType = SortType.lowToHigh,
    this.productType = const<ProductType>[],
    this.productTypeId = -1
  });
  FavoritesInitial copyWith(
  {
    List<ProductModel>? productModels,
    List<ProductType>? productType,
    ModelType ? modelType,
    SortType ? sortType,
    int? productTypeId,
  }){
    return FavoritesInitial(
      productModels: productModels ?? this.productModels,
      modelType: modelType ?? this.modelType,
      sortType: sortType ?? this.sortType,
      productType: productType ?? this.productType,
      productTypeId: productTypeId ?? this.productTypeId
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [productModels,DateTime.now().millisecondsSinceEpoch,modelType,sortType,productType,productTypeId];
}

