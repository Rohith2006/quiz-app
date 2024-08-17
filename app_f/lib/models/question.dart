// lib/models/question.dart

class Question {
  final String id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String difficulty;
  final String hint;

  Question({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.difficulty,
    required this.hint,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      optionA: json['option_a'],
      optionB: json['option_b'],
      optionC: json['option_c'],
      optionD: json['option_d'],
      correctAnswer: json['correct_answer'],
      difficulty: json['difficulty'],
      hint: json['hint'],
    );
  }

  List<String> get options => [optionA, optionB, optionC, optionD];

  int get correctOptionIndex {
    switch (correctAnswer) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      default:
        throw Exception('Invalid correct_answer: $correctAnswer');
    }
  }
}