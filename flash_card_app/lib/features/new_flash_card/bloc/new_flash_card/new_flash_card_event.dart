part of 'new_flash_card_bloc.dart';

@immutable
sealed class NewFlashCardEvent {}
final class QuestionChanged extends NewFlashCardEvent{
  final String question;

  QuestionChanged(this.question);
}
final class FormInitial extends NewFlashCardEvent{
  final bool isAdd;

  FormInitial({required this.isAdd});
}
final class QuestionImageChanged extends NewFlashCardEvent{
  final String questionImage;
  QuestionImageChanged({required this.questionImage});
}
final class ColorQuestionSelected extends NewFlashCardEvent{
  final String color;

  ColorQuestionSelected(this.color);
}
final class ToggleSelected extends NewFlashCardEvent{
  final int index;

  ToggleSelected(this.index);
}
final class AddImage extends NewFlashCardEvent{
  final bool isFont;

  AddImage({required this.isFont});
}

final class AnswerChanged extends NewFlashCardEvent{
  final String answer;

  AnswerChanged(this.answer);
}
final class AnswerImageChanged extends NewFlashCardEvent{
  final String answerImage;

  AnswerImageChanged(this.answerImage);
}
final class AnswerAudioChanged extends NewFlashCardEvent{
  final String answerAudio;

  AnswerAudioChanged(this.answerAudio);
}
final class ColorAnswerChanged extends NewFlashCardEvent{
  final String colorAnswer;

  ColorAnswerChanged(this.colorAnswer);
}
final class SaveEvent extends NewFlashCardEvent{

}
final class AddFile extends NewFlashCardEvent{}
final class SaveButtonEvent extends NewFlashCardEvent{}
final class SaveFlashCard extends NewFlashCardEvent{
  final Flashcard flashCard;

  SaveFlashCard(this.flashCard);
}