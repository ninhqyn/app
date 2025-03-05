import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/shop/bloc/shop_bloc.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:ecommerce_app/shop/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:favorite_repository/favorite_repository.dart';
import 'package:meta/meta.dart';
import 'package:product_api/product_api.dart';
import 'package:product_repository/product_repository.dart';
import 'package:product_type_repository/product_type_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc( {
    required this.productRepository,
    required this.authenticationRepository,
    required this.favoriteRepository,
    required this.productTypeRepository
   }) : super(FavoritesInitial()) {
    on<FetchDataProductFavorites>(_onFetchData);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<AddToFavorite>(_onAddToFavorite);
    on<FavoriteModelChanged>(_onFavoriteModelChanged);
    on<FavoriteSortChanged>(_onFavoriteSortChanged);
    on<FavoriteSelectProductType>(_onFavoriteSelectProductType);
  }
  final ProductTypeRepository productTypeRepository;
  final ProductRepository productRepository;
  final AuthenticationRepository authenticationRepository;
  final FavoriteRepository favoriteRepository;

  Future<void> _onFavoriteSelectProductType(FavoriteSelectProductType event,Emitter<FavoritesState> emit) async{
    print('select product type');
  }
  Future<void> _onFavoriteModelChanged(FavoriteModelChanged event,Emitter<FavoritesState> emit )async{
    if(state is FavoritesInitial){
      final currentState = state as FavoritesInitial;
      emit(currentState.copyWith(modelType: event.modelType));
    }
  }
  Future<void> _onFavoriteSortChanged(FavoriteSortChanged event,Emitter<FavoritesState> emit) async{
    if(state is FavoritesInitial){
      final currentState = state as FavoritesInitial;
      emit(currentState.copyWith(sortType: event.sortType));
    }
  }
  Future<void> _onAddToFavorite (AddToFavorite event,Emitter<FavoritesState> emit) async{
    final tokenModel = await authenticationRepository.getTokenModel();
    final response = await favoriteRepository.addFavorite(event.productId, tokenModel.accessToken);

    if (response.success) {
      if (state is FavoritesInitial) {
        final currentState = state as FavoritesInitial;

        List<Product> products = await productRepository.getAllProductFavorite(tokenModel.accessToken);
        List<Future<List<ProductImage>>> imageFutures = products.map((product) {
          return  productRepository.getAllProductImage(product.productId);
        }).toList();

        // Chờ tất cả các API trả về cùng lúc
        List<List<ProductImage>> allImages = await Future.wait(imageFutures);
        List<ProductModel> productModels = [];
        for (int i = 0; i < products.length; i++) {
          productModels.add(ProductModel(
            product: products[i],
            productImages: allImages[i],
          ));
        }

        emit(currentState.copyWith(productModels: productModels));
      }
    }
  }
  Future<void> _onRemoveFavorite(RemoveFavorite event, Emitter<FavoritesState> emit) async {
    final tokenModel = await authenticationRepository.getTokenModel();
    final response = await favoriteRepository.removeFavorite(event.productId, tokenModel.accessToken);
    if (response) {
      if (state is FavoritesInitial) {
        final currentState = state as FavoritesInitial;
        final listNewModel = List<ProductModel>.from(currentState.productModels);
        listNewModel.removeWhere((item) => item.product.productId == event.productId);
        emit(FavoritesInitial(productModels: listNewModel));
      }
    }
    print('removed: ${event.productId}');

  }

  Future<void> _onFetchData (FetchDataProductFavorites event, Emitter<FavoritesState> emit) async{
    final tokenModel = await authenticationRepository.getTokenModel();
    List<Product> products = await productRepository.getAllProductFavorite(tokenModel.accessToken);
    List<Future<List<ProductImage>>> imageFutures = products.map((product) {
      return  productRepository.getAllProductImage(product.productId);
    }).toList();

    // Chờ tất cả các API trả về cùng lúc
    List<List<ProductImage>> allImages = await Future.wait(imageFutures);
    List<ProductModel> productModels = [];
    for (int i = 0; i < products.length; i++) {
      productModels.add(ProductModel(
        product: products[i],
        productImages: allImages[i],
      ));
    }
    final productTypes = await productTypeRepository.getAllProductType();
    emit(FavoritesInitial(productModels: productModels,productType: productTypes));


  }
}
