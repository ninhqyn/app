part of 'shop_bloc.dart';
enum SortType { lowToHigh, highToLow,popular, newest, customerReview }
enum ModelType { grid,list}
@immutable
sealed class ShopState extends Equatable {
  final List<ShopState> navigationStack;

  ShopState({List<ShopState>? navigationStack})
      : navigationStack = navigationStack ?? [];
  ShopState copyWithStack(List<ShopState> stack) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [navigationStack];
}

class ShopInitial extends ShopState {
  @override
  List<Object?> get props => [];

  @override
  ShopInitial copyWithStack(List<ShopState> stack) {
    return this; // Initial state không cần lưu stack
  }
}

class LoadingState extends ShopState {
  @override
  List<Object?> get props => [];

  @override
  LoadingState copyWithStack(List<ShopState> stack) {
    return this; // Loading state không cần lưu stack
  }
}

class CategoriesLoadedState extends ShopState {
  final List<Category> categoriesParent;
  final List<Category> categories;
  final int tabIndex;

  CategoriesLoadedState({
    required this.categoriesParent,
    required this.categories,
    this.tabIndex = 0,
    List<ShopState>? navigationStack,
  }) : super(navigationStack: navigationStack ?? []);

  @override
  CategoriesLoadedState copyWithStack(List<ShopState> stack) {
    return CategoriesLoadedState(
      categoriesParent: categoriesParent,
      categories: categories,
      tabIndex: tabIndex,
      navigationStack: stack,
    );
  }

  CategoriesLoadedState copyWith({
    List<Category>? categoriesParent,
    List<Category>? categories,
    int? tabIndex,
    List<ShopState>? navigationStack,
  }) {
    return CategoriesLoadedState(
      categoriesParent: categoriesParent ?? this.categoriesParent,
      categories: categories ?? this.categories,
      tabIndex: tabIndex ?? this.tabIndex,
      navigationStack: navigationStack ?? this.navigationStack,
    );
  }

  @override
  List<Object?> get props => [categories, tabIndex, navigationStack,categoriesParent];
}

class ProductTypeLoadedState extends ShopState {
  final int categoryId;
  final List<ProductType> productTypes;

  ProductTypeLoadedState(
      this.categoryId,
      this.productTypes, {
        List<ShopState>? navigationStack,
      }) : super(navigationStack: navigationStack ?? []);

  @override
  ProductTypeLoadedState copyWithStack(List<ShopState> stack) {
    return ProductTypeLoadedState(
      categoryId,
      productTypes,
      navigationStack: stack,
    );
  }

  @override
  List<Object?> get props => [categoryId, productTypes, navigationStack];
}

class ProductLoadedState extends ShopState {
  final ProductType productType;
  final List<ProductType> productTypes;
  final List<ProductModel> filterProducts;
  final List<ProductModel> productModels;
  final ModelType modelType;
  final SortType sortType;
  final FilterModel filter;

  // Constructor
  ProductLoadedState({
    required this.productType,
    required this.productTypes,
    required this.productModels,
    this.modelType = ModelType.list,
    this.sortType = SortType.lowToHigh,
    this.filter = const FilterModel.empty(),
    List<ShopState>? navigationStack,  // Named parameter for navigationStack
  }) : filterProducts = _filterProducts(productModels, filter)
   ,super(navigationStack: navigationStack ?? []);  // Use empty list if null
  static List<ProductModel> _filterProducts(List<ProductModel> products, FilterModel? filter) {
     List<ProductModel> list = [];
     return list;
  }
  ProductLoadedState copyWith({
    ProductType? productType,
    List<Product>? products,
    List<ProductType>? productTypes,
    List<ProductModel>? productModels,
    ModelType? modelType,
    SortType? sortType,
    FilterModel? filter,
    List<ShopState>? stack,
    bool? navigatorBrand
  }) {
    return ProductLoadedState(
      productType: productType ?? this.productType,
      productTypes: productTypes ?? this.productTypes,
      productModels: productModels ?? this.productModels,
      modelType: modelType ?? this.modelType,
      sortType: sortType ?? this.sortType,
      navigationStack: navigationStack,
      filter: filter ?? this.filter,
    );
  }
  // @override
  // ProductLoadedState copyWithStack(List<ShopState> stack) {
  //   return ProductLoadedState(
  //     productTypeId: productTypeId,
  //     products: products,
  //     modelType: modelType,
  //     sortType: sortType,
  //     navigationStack: stack,
  //   );
  // }


  @override
  List<Object?> get props => [productType, navigationStack,modelType,sortType,filter,productTypes,productModels];

}
