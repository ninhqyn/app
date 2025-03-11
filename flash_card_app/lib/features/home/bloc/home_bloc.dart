import 'package:bloc/bloc.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flash_card_app/sql/sqlite.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchData>(_onFetchData);
  }
  Future<void> _onFetchData(FetchData event,Emitter<HomeState> emit) async{
    emit(HomeLoading());
    try{
      final myCards = await SQLiteHelper.getFlashcardsByList('AllFlashCard');
      List<List<Flashcard>> myLists = [];
      myLists = await SQLiteHelper.getAllFlashcardsGroupedByList();
      emit(HomeLoaded(myCards: myCards, myLists: myLists));
    }catch(e){
      throw Exception(e);
    }
  }
}
