import 'dart:ui';


import 'package:ecommerce_app/shop/models/category.dart';
import 'package:equatable/equatable.dart';

import 'brand.dart';
enum SizeProduct{
  M,S,L,xL,xxL
}
class FilterModel extends Equatable{
  final int? startRange;
  final int? endRange;
  final List<Color>? colors;
  final List<SizeProduct>? sizes;
  final Category? category;
  final List<Brand>? brands;

  const FilterModel({
    this.startRange,
    this.endRange,
    this.colors,
    this.sizes,
    this.category,
    this.brands,
});
  FilterModel copyWith({
    int? startRange,
    int? endRange,
    List<Color>? colors,
    List<SizeProduct>? sizes,
    Category? category,
    List<Brand>? brands
}){
    return FilterModel(
      startRange: startRange ?? this.startRange,
      endRange:  endRange ?? this.endRange,
      colors: colors?? this.colors,
        sizes: sizes ?? this.sizes,
      category: category ??  this.category,
      brands: brands?? this.brands
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [startRange,endRange,colors,sizes,brands,category];
}