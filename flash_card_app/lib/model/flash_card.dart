class Flashcard {
  final int? id;
  final String question;
  final String? questionImage;  // Đường dẫn ảnh câu hỏi
  final String questionColor;
  final String answer;
  final String answerColor;
  final String? audioFile;
  final String? answerImage;
   String listName;

  Flashcard({
    this.id,
    required this.question,
    this.questionImage,
    required this.questionColor,
    required this.answer,
    required this.answerColor,
    this.audioFile,
    this.answerImage,
    required this.listName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'questionImage': questionImage,
      'questionColor': questionColor,
      'answer': answer,
      'answerColor': answerColor,
      'audioFile': audioFile,
      'answerImage': answerImage,
      'listName': listName,
    };
  }

  static Flashcard fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      question: map['question'],
      questionImage: map['questionImage'],
      questionColor: map['questionColor'],
      answer: map['answer'],
      answerColor: map['answerColor'],
      audioFile: map['audioFile'],
      answerImage: map['answerImage'],
      listName: map['listName'],
    );
  }
}
