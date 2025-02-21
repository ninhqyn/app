part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}
class FilterChangedFavorites extends FavoritesEvent{
  final FilterModel filterModel;

  FilterChangedFavorites(this.filterModel);
}