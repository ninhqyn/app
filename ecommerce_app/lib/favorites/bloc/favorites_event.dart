part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}
class FetchDataProductFavorites extends FavoritesEvent{}
class RemoveFavorite extends FavoritesEvent{
  final int productId;

  RemoveFavorite(this.productId);
}
class AddToFavorite extends FavoritesEvent{
  final int productId;

  AddToFavorite(this.productId);
}

class FavoriteModelChanged extends FavoritesEvent{
  final ModelType modelType;

  FavoriteModelChanged(this.modelType);
}
class FavoriteSortChanged extends FavoritesEvent{
  final SortType sortType;

  FavoriteSortChanged(this.sortType);
}
class FavoriteSelectProductType extends FavoritesEvent{
  final ProductType productType;

  FavoriteSelectProductType(this.productType);
}