import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/shop/models/category.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../models/brand.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<NavigatorBrand>(_onNavigatorBrand);
    on<NavigatorBack>(_onNavigatorBack);
    on<SelectPrice>(_onSelectPrice);
    on<SelectBrand>(_onSelectBrand);
    on<DeselectBrand>(_onDeselectBrand);
    on<SelectSize>(_onSelectSize);
    on<DeselectSize>(_onDeselectSize);
    on<SelectColor>(_onSelectColor);
    on<DeselectColor>(_onDeselectColor);
     on<SelectCategory>(_onSelectCategory);
  }
  void _onSelectColor(SelectColor event, Emitter<FilterState> emit) {
    final updatedColors = List<Color>.from(state.filterModel?.colors ?? []);
    updatedColors.add(event.color); // Add selected color

    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
      colors: updatedColors,
    );

    emit(state.copyWith(filterModel: newFilterModel));
  }

  void _onDeselectColor(DeselectColor event, Emitter<FilterState> emit) {
    final updatedColors = List<Color>.from(state.filterModel?.colors ?? []);
    updatedColors.remove(event.color); // Remove deselected color

    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
      colors: updatedColors,
    );

    emit(state.copyWith(filterModel: newFilterModel));
  }

  void _onSelectSize(SelectSize event, Emitter<FilterState> emit) {
    final updatedSizes = List<SizeProduct>.from(state.filterModel?.sizes ?? []);
    updatedSizes.add(event.size); // Add selected size

    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
      sizes: updatedSizes,
    );

    emit(state.copyWith(filterModel: newFilterModel));
  }

  void _onDeselectSize(DeselectSize event, Emitter<FilterState> emit) {
    final updatedSizes = List<SizeProduct>.from(state.filterModel?.sizes ?? []);
    updatedSizes.remove(event.size); // Remove deselected size

    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
      sizes: updatedSizes,
    );

    emit(state.copyWith(filterModel: newFilterModel));
  }


  void _onSelectBrand(SelectBrand event, Emitter<FilterState> emit) {
    final updatedBrands = List<Brand>.from(state.filterModel?.brands ?? []);
    updatedBrands.add(event.brand); // Add the selected brand

    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
      brands: updatedBrands,
    );

    emit(state.copyWith(filterModel: newFilterModel));
  }

  // Handle deselecting a brand
  void _onDeselectBrand(DeselectBrand event, Emitter<FilterState> emit) {
    final updatedBrands = List<Brand>.from(state.filterModel?.brands ?? []);
    updatedBrands.remove(event.brand); // Remove the deselected brand

    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
      brands: updatedBrands,
    );

    emit(state.copyWith(filterModel: newFilterModel));
  }

  void _onSelectCategory(SelectCategory event, Emitter<FilterState> emit) {

    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
      category: event.category,
    );

    emit(state.copyWith(filterModel: newFilterModel));
  }



  void _onSelectPrice(SelectPrice event, Emitter<FilterState> emit) {
    // Tạo filterModel mới từ filterModel hiện tại hoặc tạo mới nếu chưa có
    final newFilterModel = (state.filterModel ?? const FilterModel()).copyWith(
        startRange: event.startRange,
        endRange: event.endRange
    );

    // Emit state mới với filterModel đã cập nhật
    emit(state.copyWith(filterModel: newFilterModel));
    print(state.filterModel!.startRange);
  }
  void _onNavigatorBrand(NavigatorBrand event,Emitter<FilterState> emit){
    emit(state.copyWith(navigatorBrand:true));
  }
  void _onNavigatorBack(NavigatorBack event,Emitter<FilterState> emit){
    emit(state.copyWith(navigatorBrand:false));
  }


}
