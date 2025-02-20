part of 'filter_bloc.dart';

@immutable
final class FilterState extends Equatable{
  final FilterModel? filterModel;
  final bool navigatorBrand;
  const FilterState({
    this.navigatorBrand = false,
    this.filterModel
 });
  FilterState copyWith({
    bool? navigatorBrand,
    FilterModel? filterModel
 }){
    return FilterState(
      filterModel: filterModel ?? this.filterModel,
      navigatorBrand: navigatorBrand ?? this.navigatorBrand
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [navigatorBrand,filterModel];
}
