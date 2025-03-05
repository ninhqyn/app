part of 'shop_bloc.dart';

@immutable
sealed class ShopEvent{}
class LoadCategoriesEvent extends ShopEvent{
}
class TabChanged extends ShopEvent{
  final int tabIndex;
  final int categoryId;
  TabChanged(this.tabIndex, this.categoryId);
}
class SelectCategoriesEvent extends ShopEvent{
  final int categoryId;

  SelectCategoriesEvent(this.categoryId);
}
class SelectProductTypeEvent extends ShopEvent{
  final ProductType productType;
  final int categoryId;

  SelectProductTypeEvent(this.productType,this.categoryId);
}
class NavigateBackEvent extends ShopEvent {}

final class ModelChanged extends ShopEvent{
  final ModelType modelType;
  ModelChanged(this.modelType);
}
final class SortChanged extends ShopEvent{
  final SortType sortType;

  SortChanged(this.sortType);

}
final class FilterApply extends ShopEvent{
}
final class FilterChanged extends ShopEvent{
  final FilterModel filterModel;

  FilterChanged(this.filterModel);
}
final class SelectProductTypeInList extends ShopEvent{
  final ProductType productType;

  SelectProductTypeInList(this.productType);
}