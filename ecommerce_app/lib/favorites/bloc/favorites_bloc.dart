import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/shop/models/filter_model.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<FilterChangedFavorites>(_onFilterChanged);
  }
  void _onFilterChanged (FilterChangedFavorites event, Emitter<FavoritesState> emit){
    print('filter favorites');
  }
}
