part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable{}

final class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}
final class HomeLoading extends HomeState{
  @override
  List<Object?> get props => [];
}
final class HomeLoaded extends HomeState{
  final List<Flashcard> myCards;
  final List<List<Flashcard>> myLists;

  HomeLoaded({
    required this.myCards,
    required this.myLists
});
  HomeLoaded copyWith({
    List<Flashcard>? myCards,
    List<List<Flashcard>>? myLists}){
    return HomeLoaded(
        myCards: myCards ?? this.myCards,
        myLists: myLists ?? this.myLists);
  }
  @override
  List<Object?> get props => [myCards,myLists,DateTime.now()];
}
