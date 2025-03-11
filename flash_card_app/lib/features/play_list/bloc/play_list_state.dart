part of 'play_list_bloc.dart';
enum FetchStatus{
  fail,
  success,
  error,
  initial
}
@immutable
sealed class PlayListState extends Equatable{}

final class PlayListInitial extends PlayListState {
  final List<Flashcard> listSelected;
  final List<Flashcard> listCards;
  final List<Flashcard> listChoose;
  PlayListInitial({
    this.listSelected =const<Flashcard>[],
    this.listCards =const<Flashcard>[],
    this.listChoose = const[]
});
  PlayListInitial copyWith({
    List<Flashcard>? listSelected,
    List<Flashcard>? listChoose,
    List<Flashcard>? listCards}){
    return PlayListInitial(
      listSelected:  listSelected ?? this.listSelected,
      listCards:  listCards ?? this.listCards,
      listChoose: listChoose ?? this.listChoose
    );
  }
  @override
  List<Object?> get props => [listSelected,listCards,listChoose];
}
final class PlayListChooseState extends PlayListState{
  final FetchStatus status;
  PlayListChooseState({
    this.status = FetchStatus.initial
});

  @override
  List<Object?> get props => [];
}
final class SavePlayListSuccess extends PlayListState{
  @override
  List<Object?> get props => [];
}
final class SavePlayListFailure extends PlayListState{
  final String? message;

  SavePlayListFailure(this.message);

  @override
  // TODO: implement props
  List<Object?> get props =>[message];

}