import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/shop/models/category.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:ecommerce_app/shop/models/product.dart';
import 'package:ecommerce_app/shop/models/product_type.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc() : super( ShopInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<TabChanged>(_onTabChanged);
    on<SelectCategoriesEvent>(_onSelectCategories);
    on<SelectProductTypeEvent>(_onSelectProductType);
    on<NavigateBackEvent>(_onNavigatorBack);
    on<ModelChanged>(_onModelChanged);
    on<SortChanged>(_onSortChanged);
    on<FilterApply>(_onFilterApply);
    on<FilterChanged>(_onFilterChanged);
  }
  void _onFilterChanged(FilterChanged event, Emitter<ShopState> emit) {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;
      emit(currentState.copyWith(filter: event.filterModel));
      final currentState2 = state as ProductLoadedState;
      print('filter changed');
      if(currentState2.filter!=null){
        print(currentState2.filter!.startRange);
        print(currentState2.filter!.endRange);
        print(currentState2.filter!.colors);
      }

    }
  }

  void _onFilterApply(FilterApply event, Emitter<ShopState> emit) {
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;
      // Có thể thêm logic khác ở đây nếu cần
      // Ví dụ: lưu filter vào local storage
      print('Filter applied: ${currentState.filter}');
      //Navigator.pop(context); // Đóng trang filter
    }
  }
  void _onSortChanged(SortChanged event,Emitter<ShopState> emit){
    if(state is ProductLoadedState){
      final currentState = state as ProductLoadedState;
      emit(currentState.copyWith(sortType: event.sortType));
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
  Future<void> _onSelectProductType(SelectProductTypeEvent event,Emitter<ShopState> emit) async{
    final newStack = List<ShopState>.from(state.navigationStack)..add(state);
    emit(LoadingState());
    try{
      //await Future.delayed(const Duration(seconds: 1));
      // Thực hiện hành động sau 5 giây
      print('Loading list product');
      List<Product> products =[];
      emit(ProductLoadedState(productTypeId: event.productTypeId,products: products,navigationStack: newStack));
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> _onSelectCategories(SelectCategoriesEvent event, Emitter<ShopState> emit) async{
    final newStack = List<ShopState>.from(state.navigationStack)..add(state);
    emit(LoadingState());
    try{
      //await Future.delayed(const Duration(seconds: 1));
      // Thực hiện hành động sau 5 giây
      print('Loading list product type');
      List<ProductType> productTypes =[];
      emit(ProductTypeLoadedState(event.categoryId, productTypes,navigationStack: newStack));
    }catch(e){
      print(e.toString());
    }
  }
  void _onTabChanged(TabChanged event, Emitter<ShopState> emit) {
    if (state is CategoriesLoadedState) {
      final currentState = state as CategoriesLoadedState;
      emit(currentState.copyWith(tabIndex: event.tabIndex));
    }
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event , Emitter<ShopState> emit) async{
    emit(LoadingState());
    try{
      //await Future.delayed(const Duration(seconds: 1));
      // Thực hiện hành động sau 5 giây
      print('Đã trễ 5 giây');
      List<Category> categories =[
        Category(1, "Quan ao"),
        Category(2, "Trang suc"),
        Category(3, "Giay dep"),
        Category(4, 'Phu kien')
      ];
      emit(CategoriesLoadedState(categories: categories));
    }catch(e){
      print('error:' + e.toString());
    }
  }
}
