part of 'shop_bloc.dart';
enum SortType { lowToHigh, highToLow,popular, newest, customerReview }
enum ModelType { grid,list}
@immutable
sealed class ShopState extends Equatable {
  final List<ShopState> navigationStack;

  ShopState({List<ShopState>? navigationStack})
      : navigationStack = navigationStack ?? [];

  // Method để cập nhật navigation stack cho mỗi state
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
  final List<Category> categories;
  final int tabIndex;

  CategoriesLoadedState({
    required this.categories,
    this.tabIndex = 0,
    List<ShopState>? navigationStack,
  }) : super(navigationStack: navigationStack ?? []);

  @override
  CategoriesLoadedState copyWithStack(List<ShopState> stack) {
    return CategoriesLoadedState(
      categories: categories,
      tabIndex: tabIndex,
      navigationStack: stack,
    );
  }

  CategoriesLoadedState copyWith({
    List<Category>? categories,
    int? tabIndex,
    List<ShopState>? navigationStack,
  }) {
    return CategoriesLoadedState(
      categories: categories ?? this.categories,
      tabIndex: tabIndex ?? this.tabIndex,
      navigationStack: navigationStack ?? this.navigationStack,
    );
  }

  @override
  List<Object?> get props => [categories, tabIndex, navigationStack];
}

class ProductTypeLoadedState extends ShopState {
  final String categoryId;
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
  final String productTypeId;
  final List<Product> products;
  final List<Product> filterProducts;
  final ModelType modelType;
  final SortType sortType;
  final FilterModel? filter;

  // Constructor
  ProductLoadedState({
    required this.productTypeId,
    required this.products,
    this.modelType = ModelType.list,
    this.sortType = SortType.newest,
    this.filter,
    List<ShopState>? navigationStack,  // Named parameter for navigationStack
  }) : filterProducts = _filterProducts(products, filter)
   ,super(navigationStack: navigationStack ?? []);  // Use empty list if null
  static List<Product> _filterProducts(List<Product> products, FilterModel? filter) {
     List<Product> list = [];
     return list;
  }
  ProductLoadedState copyWith({
    String? productTypeId,
    List<Product>? products,
    ModelType? modelType,
    SortType? sortType,
    FilterModel? filter,
    List<ShopState>? stack,
    bool? navigatorBrand
  }) {
    return ProductLoadedState(
      productTypeId: productTypeId ?? this.productTypeId,
      products: products ?? this.products,
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
  List<Object?> get props => [productTypeId, products, navigationStack,modelType,sortType,filter];

}
