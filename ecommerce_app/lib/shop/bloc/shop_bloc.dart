
import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:ecommerce_app/shop/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:product_api/product_api.dart';
import 'package:product_repository/product_repository.dart';
import 'package:product_type_repository/product_type_repository.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final CategoryRepository categoryRepository;
  final ProductTypeRepository productTypeRepository;
  final ProductRepository productRepository;
  ShopBloc(this.categoryRepository,this.productTypeRepository, this.productRepository) : super( ShopInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<TabChanged>(_onTabChanged);
    on<SelectCategoriesEvent>(_onSelectCategories);
    on<SelectProductTypeEvent>(_onSelectProductType);
    on<NavigateBackEvent>(_onNavigatorBack);
    on<ModelChanged>(_onModelChanged);
    on<SortChanged>(_onSortChanged);
    on<FilterApply>(_onFilterApply);
    on<FilterChanged>(_onFilterChanged);
    on<SelectProductTypeInList>(_onSelectProductTypeInList);
  }
  Future<void> _onSelectProductTypeInList(SelectProductTypeInList event, Emitter<ShopState> emit) async {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;

      // Lấy danh sách id màu sắc từ filter.colors
      List<int>? colorIds;
      if (currentState.filter.colors?.isNotEmpty ?? false) {
        colorIds = currentState.filter.colors!.map((color) => color.colorId).toList();
      }

      // Lấy danh sách size từ filter.sizes
      List<int>? sizeIds;
      if (currentState.filter.sizes?.isNotEmpty ?? false) {
        sizeIds = currentState.filter.sizes!.map((size) => size.sizeId).toList();
      }

      // Lấy thông tin nhãn hiệu (brand)
      List<String>? brandList;
      if (currentState.filter.brands?.isNotEmpty ?? false) {
        brandList = currentState.filter.brands!.map((brand) => brand.brand).toList();
      }

      // Lấy sortType từ event
      String? sortString;
      switch (currentState.sortType) {
        case SortType.lowToHigh:
          sortString = 'priceasc';
          break;
        case SortType.highToLow:
          sortString = 'pricedesc';
          break;
        case SortType.customerReview:
          sortString = 'rating';
          break;
        case SortType.popular:
          sortString = 'popular';
          break;
        case SortType.newest:
          sortString = 'new';
          break;
        default:
          sortString = null;
      }

      try {
        // Gọi repository để lấy sản phẩm đã lọc
        final productFilters = await productRepository.getAllProductFilter(
          minPrice: currentState.filter.startRange?.toDouble(),
          maxPrice: currentState.filter.endRange?.toDouble(),
          colors: colorIds,  // Sử dụng danh sách id màu sắc
          sizes: sizeIds,    // Sử dụng danh sách id size
          brands: brandList, // Sử dụng danh sách brand
          typeId: event.productType.typeId,
          sortBy: sortString, // Sử dụng sortString từ event
        );

        List<ProductModel> productModels = [];
        productModels = await getData(productFilters);

        // Emit state mới với dữ liệu sản phẩm đã lấy
        emit(currentState.copyWith(
          productType: event.productType,
          productModels: productModels,
        ));
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> _onFilterChanged(FilterChanged event, Emitter<ShopState> emit) async {
    if (state is ProductLoadedState) {
      final currentState2 = state as ProductLoadedState;

      emit(currentState2.copyWith(
        filter: event.filterModel,
      ));
      final currentState = state as ProductLoadedState;
      // Lấy danh sách id màu sắc từ filter.colors
      List<int>? colorIds;
      if (currentState.filter.colors?.isNotEmpty ?? false) {
        colorIds = currentState.filter.colors!.map((color) => color.colorId).toList();
      }

      // Lấy danh sách size từ filter.sizes
      List<int>? sizeIds;
      if (currentState.filter.sizes?.isNotEmpty ?? false) {
        sizeIds = currentState.filter.sizes!.map((size) => size.sizeId).toList();

        for(int i=0;i<sizeIds.length;i++){
          print(sizeIds[i]);
          print(currentState.filter.sizes![i].name);
        }
      }


      // Lấy thông tin nhãn hiệu (brand)
      List<String>? brandList;
      if (currentState.filter.brands?.isNotEmpty ?? false) {
        brandList = currentState.filter.brands!.map((brand) => brand.brand).toList();
      }

      // Lấy sortType từ event
      String? sortString;
      switch (currentState.sortType) {
        case SortType.lowToHigh:
          sortString = 'priceasc';
          break;
        case SortType.highToLow:
          sortString = 'pricedesc';
          break;
        case SortType.customerReview:
          sortString = 'rating';
          break;
        case SortType.popular:
          sortString = 'popular';
          break;
        case SortType.newest:
          sortString = 'new';
          break;
        default:
          sortString = null;
      }


        // Gọi repository để lấy sản phẩm đã lọc
        final productFilters =  await productRepository.getAllProductFilter(
          minPrice: currentState.filter.startRange?.toDouble(),
          maxPrice: currentState.filter.endRange?.toDouble(),
          colors: colorIds,  // Sử dụng danh sách id màu sắc
          sizes: sizeIds,    // Sử dụng danh sách id size
          brands: brandList, // Sử dụng danh sách brand
          typeId: currentState.productType.typeId,
          sortBy: sortString, // Sử dụng sortString từ event
        );
      List<ProductModel> productModels = await getData(productFilters);
      emit(currentState.copyWith(
          products: productFilters,
          productModels: productModels,
      ));

    }
  }

  void _onFilterApply(FilterApply event, Emitter<ShopState> emit) {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;
      print('Filter applied: ${currentState.filter}');
    }
  }
  Future<void> _onSortChanged(SortChanged event, Emitter<ShopState> emit) async {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;

      List<int>? colorIds;
      if (currentState.filter.colors?.isNotEmpty ?? false) {
        colorIds = currentState.filter.colors!.map((color) => color.colorId).toList();
      }

      // Lấy danh sách size từ filter.sizes
      List<int>? sizeIds;
      if (currentState.filter.sizes?.isNotEmpty ?? false) {
        sizeIds = currentState.filter.sizes!.map((size) => size.sizeId).toList();
      }

      // Lấy thông tin nhãn hiệu (brand)
      List<String>? brandList;
      if (currentState.filter.brands?.isNotEmpty ?? false) {
        brandList = currentState.filter.brands!.map((brand) => brand.brand).toList();
      }

      // Lấy sortType từ event
      String? sortString;
      switch (currentState.sortType) {
        case SortType.lowToHigh:
          sortString = 'priceasc';
          break;
        case SortType.highToLow:
          sortString = 'pricedesc';
          break;
        case SortType.customerReview:
          sortString = 'rating';
          break;
        case SortType.popular:
          sortString = 'popular';
          break;
        case SortType.newest:
          sortString = 'new';
          break;
        default:
          sortString = null;
      }

      try {
        // Gọi repository để lấy sản phẩm đã lọc
        final productFilters = await productRepository.getAllProductFilter(
          minPrice: currentState.filter.startRange?.toDouble(),
          maxPrice: currentState.filter.endRange?.toDouble(),
          colors: colorIds,  // Sử dụng danh sách id màu sắc
          sizes: sizeIds,    // Sử dụng danh sách id size
          brands: brandList, // Sử dụng danh sách brand
          typeId: currentState.productType.typeId,
          sortBy: sortString, // Sử dụng sortString từ event
        );
        List<ProductModel> productModels = await getData(productFilters);

        // Emit lại state với sortType mới và danh sách sản phẩm đã lọc
        emit(currentState.copyWith(
          filter: currentState.filter, // Giữ nguyên filter từ currentState
          products: productFilters,
          productModels: productModels,
          sortType: event.sortType, // Cập nhật sortType từ event
        ));

      } catch (error) {
        // Xử lý lỗi nếu có vấn đề khi gọi API
        print(error);
      }
    }
  }


  void _onModelChanged(ModelChanged event,Emitter<ShopState> emit){
    if(state is ProductLoadedState){
      final currentState = state as ProductLoadedState;
      emit(currentState.copyWith(modelType: event.modelType));
    }
  }
  void _onNavigatorBack(NavigateBackEvent event, Emitter<ShopState> emit){
    if (state.navigationStack.isEmpty) return;
    print('back');
    final previousState = state.navigationStack.last;
    final newStack = List<ShopState>.from(state.navigationStack)..removeLast();

    if (previousState is CategoriesLoadedState) {
      emit(previousState.copyWith(navigationStack: newStack));
    } else {
      emit(previousState);
    }
  }
  Future<List<ProductModel>> getData(List<Product> list) async{
    // Lấy hình ảnh sản phẩm
    List<Future<List<ProductImage>>> imageFutures = list.map((product) {
      return productRepository.getAllProductImage(product.productId);
    }).toList();

    // Chờ tất cả các API trả về cùng lúc
    List<List<ProductImage>> allImages = await Future.wait(imageFutures);

    // Tạo danh sách các ProductModel
    List<ProductModel> productModels = [];
    for (int i = 0; i < list.length; i++) {
      productModels.add(ProductModel(
        product: list[i],
        productImages: allImages[i],
      ));
    }
    return productModels;
  }

  Future<void> _onSelectProductType(SelectProductTypeEvent event, Emitter<ShopState> emit) async {
    final newStack = List<ShopState>.from(state.navigationStack)..add(state);
    emit(LoadingState());
    try {
      List<ProductModel> productModels = [];
      List<ProductType> productTypes = [];
      productTypes = await productTypeRepository.getAllProductTypeByParent(event.categoryId);
      emit(ProductLoadedState(
        productType: event.productType,
        productTypes: productTypes,
        productModels: productModels,
        navigationStack: newStack,
      ));
      if (state is ProductLoadedState) {
        final currentState = state as ProductLoadedState;

        List<int>? colorIds;
        if (currentState.filter.colors?.isNotEmpty ?? false) {
          colorIds = currentState.filter.colors!.map((color) => color.colorId).toList();
        }

        // Lấy danh sách size từ filter.sizes
        List<int>? sizeIds;
        if (currentState.filter.sizes?.isNotEmpty ?? false) {
          sizeIds = currentState.filter.sizes!.map((size) => size.sizeId).toList();
        }

        // Lấy thông tin nhãn hiệu (brand)
        List<String>? brandList;
        if (currentState.filter.brands?.isNotEmpty ?? false) {
          brandList = currentState.filter.brands!.map((brand) => brand.brand).toList();
          for(int i=0;i<brandList.length;i++){
            print(brandList[i]);
          }
        }

        // Lấy sortType từ event
        String? sortString;
        switch (currentState.sortType) {
          case SortType.lowToHigh:
            sortString = 'priceasc';
            break;
          case SortType.highToLow:
            sortString = 'pricedesc';
            break;
          case SortType.customerReview:
            sortString = 'rating';
            break;
          case SortType.popular:
            sortString = 'popular';
            break;
          case SortType.newest:
            sortString = 'new';
            break;
          default:
            sortString = null;
        }

        try {
          // Gọi repository để lấy sản phẩm đã lọc
          final productFilters = await productRepository.getAllProductFilter(
            minPrice: currentState.filter.startRange?.toDouble(),
            maxPrice: currentState.filter.endRange?.toDouble(),
            colors: colorIds,  // Sử dụng danh sách id màu sắc
            sizes: sizeIds,    // Sử dụng danh sách id size
            brands: brandList, // Sử dụng danh sách brand
            typeId: event.productType.typeId,
            sortBy: sortString, // Sử dụng sortString từ event
          );
          productModels = await getData(productFilters);
          emit(currentState.copyWith(
            filter: currentState.filter,
            products: productFilters,
            productModels: productModels,
            sortType: currentState.sortType,
          ));

        } catch (error) {
          print(error);
        }
      }


    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> _onSelectCategories(SelectCategoriesEvent event, Emitter<ShopState> emit) async{
    final newStack = List<ShopState>.from(state.navigationStack)..add(state);
    emit(LoadingState());
    try{
     print(event.categoryId);
      List<ProductType> productTypes =await productTypeRepository.getAllProductTypeByParent(event.categoryId);
      emit(ProductTypeLoadedState(event.categoryId, productTypes,navigationStack: newStack));
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> _onTabChanged(TabChanged event, Emitter<ShopState> emit)  async {
    if (state is CategoriesLoadedState) {
      List<Category> list = await categoryRepository.getAllCategoryByParentId(event.categoryId);
      final currentState = state as CategoriesLoadedState;
      emit(currentState.copyWith(tabIndex: event.tabIndex,categories: list));

    }
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event , Emitter<ShopState> emit) async{
    emit(LoadingState());
    try{
      final categoriesParent = await categoryRepository.getAllCategoryParent();
      final categories = await categoryRepository.getAllCategoryByParentId(1);
      emit(CategoriesLoadedState(categories: categories,categoriesParent: categoriesParent));
      print('success');
    }catch(e){
      print('error:' + e.toString());
    }
  }
}
