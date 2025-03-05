part of 'filter_bloc.dart';

@immutable
final class FilterState extends Equatable{
  final FilterModel? filterModel;
  final List<SizeProduct> sizes;
  final List<ColorProduct> colors;
  final List<Brand> brands;
  final bool navigatorBrand;
  const FilterState({
    this.navigatorBrand = false,
    this.filterModel,
    required this.sizes,
    required this.colors,
    required this.brands
 });
  FilterState copyWith({
    bool? navigatorBrand,
    FilterModel? filterModel,
    List<SizeProduct>? sizes,
    List<ColorProduct>? colors,
    List<Brand>? brands

 }){
    return FilterState(
      filterModel: filterModel ?? this.filterModel,
      navigatorBrand: navigatorBrand ?? this.navigatorBrand,
      sizes:  sizes ?? this.sizes,
      colors: colors ?? this.colors,
      brands: brands ?? this.brands
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [navigatorBrand,filterModel,colors,sizes,brands];
}
