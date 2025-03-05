part of 'filter_bloc.dart';

@immutable
sealed class FilterEvent {}
class LoadedFilterScreen extends FilterEvent{
  final FilterModel? filterModel;

  LoadedFilterScreen(this.filterModel);
}
class NavigatorBrand extends FilterEvent{


}
class NavigatorBack extends FilterEvent{}
final class SelectPrice extends FilterEvent{
  final int startRange;
  final int endRange;

  SelectPrice(this.startRange, this.endRange);
}
class SelectBrand extends FilterEvent {
  final Brand brand;

  SelectBrand(this.brand);
}

class DeselectBrand extends FilterEvent {
  final Brand brand;

  DeselectBrand(this.brand);
}
class SelectColor extends FilterEvent {
  final ColorProduct color;

  SelectColor(this.color);
}

class DeselectColor extends FilterEvent {
  final ColorProduct color;

  DeselectColor(this.color);
}

class SelectSize extends FilterEvent {
  final SizeProduct size;

  SelectSize(this.size);
}

class DeselectSize extends FilterEvent {
  final SizeProduct size;

  DeselectSize(this.size);
}

class SelectCategory extends FilterEvent {
  final Category category;

  SelectCategory(this.category);
}

