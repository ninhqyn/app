part of 'play_list_bloc.dart';

@immutable
sealed class PlayListEvent {}
final class NavigatorMyFlashCardEvent extends PlayListEvent{}
final class ChooseFlashCard extends PlayListEvent{
  final Flashcard flashCard;

  ChooseFlashCard({required this.flashCard});
}
final class SavePlayList extends PlayListEvent{
  final String listName;

  SavePlayList(this.listName);
}
final class UpdateListChoose extends PlayListEvent{}
final class BackMyFlashCard extends PlayListEvent{

}