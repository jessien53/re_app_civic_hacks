class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }
}

class YesNoQuestion extends Question {
  YesNoQuestion({
    required String text,
    required String correctAnswer,
  }) : super(
    text: text,
    options: ['Yes', 'No'],
    correctAnswer: correctAnswer,
  );

  // Add a fromJson method for YesNoQuestion
  factory YesNoQuestion.fromJson(Map<String, dynamic> json) {
    return YesNoQuestion(
      text: json['question'],
      correctAnswer: json['correctAnswer'],
    );
  }
}
