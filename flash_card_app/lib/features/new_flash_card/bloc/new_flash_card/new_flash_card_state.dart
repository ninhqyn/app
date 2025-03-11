part of 'new_flash_card_bloc.dart';

@immutable
sealed class NewFlashCardState  extends Equatable{}

final class PageChanged extends NewFlashCardState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class NewFlashCardInitial extends NewFlashCardState {
  final bool isAdd;
  final bool isVideo;
  final int index;
  final String? question;
  final String? questionImage;
  final String? questionColor;
  final String? answer;
  final String? answerImage;
  final String? answerAudio;
  final String? answerColor;
  final String listName;
  NewFlashCardInitial({
    this.isAdd = false,
    this.isVideo = false,
    this.index = 0,
    this.question,
    this.questionImage,
    this.questionColor,
    this.answer,
    this.answerImage,
    this.answerAudio,
    this.answerColor,
    this.listName = 'AllFlashCard',

});
  NewFlashCardInitial copyWith({
    bool? isVideo,
    bool? isAdd,
    int? index,
    String? question,
    String? questionImage,
    String? questionColor,
    String? answer,
    String? answerImage,
    String? answerAudio,
    String? answerColor,
    String? listName,

}){
    return NewFlashCardInitial(
      isVideo: isVideo ?? this.isVideo,
      isAdd: isAdd ?? this.isAdd,
      index: index ?? this.index,
      question: question ?? this.question,
      questionImage: questionImage ?? this.questionImage,
      questionColor: questionColor ?? this.questionColor,
      answer: answer ?? this.answer,
      answerImage: answerImage ?? this.answerImage,
      answerAudio: answerAudio ?? this.answerAudio,
      answerColor: answerColor ?? this.answerColor,
      listName: listName ?? this.listName,

    );
}
  @override
  List<Object?> get props => [
    index,
    question,
    questionImage,
  questionColor,
  answer,
  answerImage,
  answerColor,
  answerAudio,
  listName,
  isAdd,
    isVideo,
  DateTime.now()];
}
final class LoadingAudioFile extends NewFlashCardState{
  @override
  List<Object?> get props => [];
}
final class LoadingImageFile extends NewFlashCardState{
  @override
  List<Object?> get props => [];
}
final class AddQuestionImageState extends NewFlashCardState{
  final bool isFont;

  AddQuestionImageState({required this.isFont});

  @override
  // TODO: implement props
  List<Object?> get props =>[isFont];

}
final class AddFileState extends NewFlashCardState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class AddImageQuestionSuccess extends NewFlashCardState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class SaveFlashCardState extends NewFlashCardState{
  final String message;
  final bool result;
  SaveFlashCardState(this.message, this.result);
  @override
  // TODO: implement props
  List<Object?> get props => [message,result];
}
final class SaveButtonState extends NewFlashCardState{
  final String? errorText;
  final bool isValid;
  final Flashcard? flashCard;
  SaveButtonState({
    this.isValid = false,
    this.errorText,
    this.flashCard
});

  @override
  // TODO: implement props
  List<Object?> get props => [errorText,isValid,flashCard];
}