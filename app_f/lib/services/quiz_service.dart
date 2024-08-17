import '../models/quiz.dart';
import '../models/question.dart';

class QuizService {
  static final List<Map<String, dynamic>> _quizHistory = [];

  List<Quiz> getQuizzes() {
    return [
      Quiz(
        name: 'General Knowledge',
        questions: [
          Question(
            questionText: 'What is the capital of France?',
            options: ['London', 'Berlin', 'Paris', 'Madrid'],
            correctOptionIndex: 2,
          ),
          Question(
            questionText: 'Who painted the Mona Lisa?',
            options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Rembrandt'],
            correctOptionIndex: 1,
          ),
        ],
      ),
      Quiz(
        name: 'Science',
        questions: [
          Question(
            questionText: 'What is the chemical symbol for water?',
            options: ['Wa', 'H2O', 'O2', 'CO2'],
            correctOptionIndex: 1,
          ),
          Question(
            questionText: 'What planet is known as the Red Planet?',
            options: ['Venus', 'Jupiter', 'Mars', 'Saturn'],
            correctOptionIndex: 2,
          ),
        ],
      ),
      Quiz(
        name: 'History',
        questions: [
          Question(
            questionText: 'In which year did World War II end?',
            options: ['1943', '1945', '1947', '1950'],
            correctOptionIndex: 1,
          ),
          Question(
            questionText: 'Who was the first President of the United States?',
            options: ['Thomas Jefferson', 'John Adams', 'George Washington', 'Benjamin Franklin'],
            correctOptionIndex: 2,
          ),
        ],
      ),
      Quiz(
        name: 'Literature',
        questions: [
          Question(
            questionText: 'Who wrote "Romeo and Juliet"?',
            options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
            correctOptionIndex: 1,
          ),
          Question(
            questionText: 'What is the name of the hobbit in "The Lord of the Rings"?',
            options: ['Bilbo', 'Frodo', 'Sam', 'Pippin'],
            correctOptionIndex: 1,
          ),
        ],
      ),
    ];
  }

Future<void> saveQuizResult(String quizName, int score) async {
    final newEntry = {
      'date': DateTime.now().toIso8601String(),
      'quizName': quizName,
      'score': score,
    };
    
    _quizHistory.add(newEntry);
  }

  Future<List<Map<String, dynamic>>> getQuizHistory() async {
    return List<Map<String, dynamic>>.from(_quizHistory)
      ..sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
  }
}