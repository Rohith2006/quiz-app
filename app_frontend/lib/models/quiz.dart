import 'question.dart';

class Quiz {
  final String name;
  final String difficulty;
  final int numberOfQuestions;
  final List<Question> questions;

  Quiz({
    required this.name,
    required this.difficulty,
    required this.numberOfQuestions,
    required this.questions,
  });

  // If you need to create a Quiz object before you have the questions,
  // you can use a factory constructor like this:
  factory Quiz.initial({
    required String name,
    required String difficulty,
    required int numberOfQuestions,
  }) {
    return Quiz(
      name: name,
      difficulty: difficulty,
      numberOfQuestions: numberOfQuestions,
      questions: [], // Start with an empty list
    );
  }

  // Method to add questions to the quiz
  void addQuestions(List<Question> newQuestions) {
    questions.addAll(newQuestions);
  }
}