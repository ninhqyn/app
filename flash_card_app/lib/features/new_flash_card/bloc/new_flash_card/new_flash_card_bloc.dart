import 'package:bloc/bloc.dart';
import 'package:flash_card_app/model/flash_card.dart';
import 'package:flash_card_app/sql/sqlite.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'new_flash_card_event.dart';
part 'new_flash_card_state.dart';

class NewFlashCardBloc extends Bloc<NewFlashCardEvent, NewFlashCardState> {
  final bool isAdd;
  //final SQLiteHelper sqLiteHelper = SQLiteHelper();
  NewFlashCardBloc({
    this.isAdd = false,
}) : super(NewFlashCardInitial()) {
    on<QuestionChanged>(_onQuestionChanged);
    on<ToggleSelected>(_onToggleSelected);
    on<AddImage>(_onAddQuestionImage);
    on<AddFile>(_onAddFileAnswer);
    on<FormInitial>(_onFormInitial);
    on<QuestionImageChanged>(_onQuestionImageChanged);
    on<ColorQuestionSelected>(_onColorQuestionSelected);
    on<AnswerChanged>(_onAnswerChanged);
    on<ColorAnswerChanged>(_onColorAnswerChanged);
    on<AnswerAudioChanged>(_onAnswerAudioChanged);
    on<AnswerImageChanged>(_onAnswerImageChanged);
    on<SaveButtonEvent>(_onSaveButtonEvent);
    on<SaveFlashCard>(_onSaveFlashCard);
  }
  //save fl
  Future<void> _onSaveFlashCard(SaveFlashCard event,Emitter<NewFlashCardState> emit) async{
    final result = await SQLiteHelper.insertFlashcard(event.flashCard);
      if(state is NewFlashCardInitial){
        final currentState = state as NewFlashCardInitial;
        if(result){
          emit(SaveFlashCardState('Success',true));
          emit(currentState);
        }else{
          emit(SaveFlashCardState('Fail to add',false));
          emit(currentState);
        }

      }

  }
  //save
  void _onSaveButtonEvent(SaveButtonEvent event, Emitter<NewFlashCardState> emit) {
    if (state is NewFlashCardInitial) {
      final currentState = state as NewFlashCardInitial;

      bool isValid = true;
      String errorText = '';
      final question = currentState.question;
      final questionImage = currentState.questionImage;
      final answer = currentState.answer;
      final answerImage = currentState.answerImage;

      if (question == null || question.isEmpty) {
        isValid = false;
        errorText = 'Câu hỏi không được để trống.';
      } else if (answer == null || answer.isEmpty) {
        isValid = false;
        errorText = 'Câu trả lời không được để trống.';
      } else if (questionImage == null || questionImage.isEmpty) {
        isValid = false;
        errorText = 'Hình ảnh câu hỏi không được để trống.';
      } else if (answerImage == null || answerImage.isEmpty) {
        isValid = false;
        errorText = 'Hình ảnh câu trả lời không được để trống.';
      }
      Flashcard fl = Flashcard(
          question: currentState.question?? '',
          questionColor: currentState.questionColor ?? 'Color(0xFFC9FA85)',
          questionImage: currentState.questionImage ?? ' ',
          answer: currentState.answer??'',
          answerColor: currentState.answerColor ?? 'Color(0xFFC9FA85)',
          answerImage: currentState.answerImage ?? '',
          audioFile: currentState.answerAudio,
          listName: currentState.listName);
      emit(SaveButtonState(isValid: isValid, errorText: errorText,flashCard: fl));
      emit(currentState);
    }
  }


  //Answer
  void _onAddFileAnswer(AddFile event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;
      emit(AddFileState());
      emit(currentState);
    }
  }
  void _onAnswerImageChanged(AnswerImageChanged event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;
      final isVideo = _isVideo(event.answerImage);
      print('Changing answerImage from ${currentState.answerImage} to ${event.answerImage}');
      emit(currentState.copyWith(answerImage: event.answerImage,isVideo: isVideo));
    }
  }
  void _onAnswerAudioChanged(AnswerAudioChanged event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;
      emit(currentState.copyWith(answerAudio: event.answerAudio));
    }
  }
  void _onAnswerChanged(AnswerChanged event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;
      emit(currentState.copyWith(answer:  event.answer));
    }
  }

  void _onColorAnswerChanged(ColorAnswerChanged event,Emitter<NewFlashCardState> emit){
    print('color ${event.colorAnswer}');
    if(state is NewFlashCardInitial){
      final current = state as NewFlashCardInitial;
      emit(current.copyWith(answerColor: event.colorAnswer));
    }
  }
  // Question
  void _onColorQuestionSelected(ColorQuestionSelected event,Emitter<NewFlashCardState> emit){
    print('color ${event.color}');
    if(state is NewFlashCardInitial){
      final current = state as NewFlashCardInitial;
      emit(current.copyWith(questionColor: event.color));
    }
  }
  void _onQuestionImageChanged(QuestionImageChanged event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;

      emit(currentState.copyWith(questionImage: event.questionImage));
      print('path: ${event.questionImage}');
    }
  }
  void _onFormInitial(FormInitial event,Emitter<NewFlashCardState> emit){
    print('${event.isAdd} int');
    emit(NewFlashCardInitial(isAdd:event.isAdd));
  }
  void _onAddQuestionImage(AddImage event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;
      emit(AddQuestionImageState(isFont: event.isFont));
      emit(AddImageQuestionSuccess());
      emit(currentState);
    }

  }
  void _onQuestionChanged(QuestionChanged event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;
      emit(currentState.copyWith(question: event.question));
    }
  }
  void _onToggleSelected(ToggleSelected event,Emitter<NewFlashCardState> emit){
    if(state is NewFlashCardInitial){
      final currentState = state as NewFlashCardInitial;
      emit(currentState.copyWith(index:event.index));
    }
  }
  bool _isVideo(String path) {
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];
    final extension = path.split('.').last.toLowerCase();
    print('file select is video ?: ${videoExtensions.contains(extension)}');
    return videoExtensions.contains(extension);
  }

}
