import 'dart:ui';
import 'package:color_repository/color_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:product_api/product_api.dart';
import 'package:size_repository/size_repository.dart';

class FilterModel extends Equatable{
  final int? startRange;
  final int? endRange;
  final List<ColorProduct>? colors;
  final List<SizeProduct>? sizes;
  final List<Brand>? brands;

  const FilterModel({
    this.startRange,
    this.endRange,
    this.colors,
    this.sizes,
    this.brands,
});
  const FilterModel.empty()
      : startRange = null,
        endRange = null,
        colors = null,
        sizes = null,
        brands = null;

  FilterModel copyWith({
    int? startRange,
    int? endRange,
    List<ColorProduct>? colors,
    List<SizeProduct>? sizes,
    List<Brand>? brands
}){
    return FilterModel(
      startRange: startRange ?? this.startRange,
      endRange:  endRange ?? this.endRange,
      colors: colors?? this.colors,
        sizes: sizes ?? this.sizes,
      brands: brands?? this.brands
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [startRange,endRange,colors,sizes,brands];
}