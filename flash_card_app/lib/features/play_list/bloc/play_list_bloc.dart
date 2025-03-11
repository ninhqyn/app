import 'package:bloc/bloc.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flash_card_app/sql/sqlite.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'play_list_event.dart';
part 'play_list_state.dart';

class PlayListBloc extends Bloc<PlayListEvent, PlayListState> {
  PlayListBloc() : super(PlayListInitial()) {
    on<NavigatorMyFlashCardEvent>(_onNavigatorMyFlash);
    on<ChooseFlashCard>(_onChooseFlashCard);
    on<UpdateListChoose>(_onUpdateListChoose);
    on<BackMyFlashCard>(_onBackMyFlashCard);
    on<SavePlayList>(_onSavePlayList);
  }
  Future<void> _onSavePlayList(SavePlayList event,Emitter<PlayListState> emit) async{
    if(state is PlayListInitial){
      final currentState = state as PlayListInitial;
      final result = await SQLiteHelper.checkListNameExists(event.listName);
      print('${event.listName}');
      if(!result){
        final list = currentState.listChoose;
        for(int i=0;i<list.length;i++){
          list[i].listName = event.listName;
        }
        for(int i=0;i<list.length;i++){
          await SQLiteHelper.updateFlashcard(list[i]);
        }
        emit(SavePlayListSuccess());
      }else{
        emit(SavePlayListFailure('The name already exists'));
        emit(currentState);
      }
      
    }
  }
  void _onBackMyFlashCard(BackMyFlashCard event,Emitter<PlayListState> emit){
    if(state is PlayListInitial){
      final currentState = state as PlayListInitial;
      if(currentState.listChoose.isEmpty){
        emit(currentState.copyWith(listSelected: const[]));
      }
    }
  }
  Future<void> _onNavigatorMyFlash(NavigatorMyFlashCardEvent event,Emitter<PlayListState> emit) async{
    if(state is PlayListInitial){
      final currentState = state as PlayListInitial;
      emit(PlayListChooseState());
      final myCards = await SQLiteHelper.getFlashcardsByList('AllFlashCard');
      print(myCards.length);
      emit(PlayListChooseState(status: FetchStatus.success));
      emit(currentState.copyWith(listCards: myCards));

    }
  }
  void _onUpdateListChoose(UpdateListChoose event,Emitter<PlayListState> emit){
    if(state is PlayListInitial){
      final currentState = state as PlayListInitial;
      List<Flashcard> updatedList = List.from(currentState.listSelected);
      print('update');
      print(updatedList.length);
      emit(currentState.copyWith(listChoose: updatedList));
    }
  }
  void _onChooseFlashCard(ChooseFlashCard event, Emitter<PlayListState> emit) {
    if (state is PlayListInitial) {
      final currentState = state as PlayListInitial;
      List<Flashcard> updatedList = List.from(currentState.listSelected);
      if (updatedList.contains(event.flashCard)) {
        updatedList.remove(event.flashCard);
      } else {
       
        updatedList.add(event.flashCard);
      }
      emit(currentState.copyWith(listSelected: updatedList));
    }
  }

}
