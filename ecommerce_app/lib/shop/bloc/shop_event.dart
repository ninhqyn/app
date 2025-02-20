part of 'shop_bloc.dart';

@immutable
sealed class ShopEvent{}
class LoadCategoriesEvent extends ShopEvent{
}
class TabChanged extends ShopEvent{
  final int tabIndex;

  TabChanged(this.tabIndex);
}
class SelectCategoriesEvent extends ShopEvent{
  final String categoryId;

  SelectCategoriesEvent(this.categoryId);
}
class SelectProductTypeEvent extends ShopEvent{
  final String productTypeId;

  SelectProductTypeEvent(this.productTypeId);
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