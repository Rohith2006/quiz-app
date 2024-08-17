import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';
import '../models/question.dart';

class QuizService {
  static const String _historyKey = 'quiz_history';
  


  Future<List<Question>> getQuestions(Quiz quiz) async {
    final response = await http.get(Uri.parse(
        'https://go-server-theta.vercel.app/get-random-questions?difficulty=${quiz.difficulty.toLowerCase()}&num=${quiz.numberOfQuestions}'));

    if (response.statusCode == 200) {
      List<dynamic> questionsJson = json.decode(response.body);
      return questionsJson.map((q) => Question.fromJson(q)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
  Future<void> saveQuizResult(String quizName, int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    final newEntry = json.encode({
      'date': DateTime.now().toIso8601String(),
      'quizName': quizName,
      'score': score,
    });
    
    history.add(newEntry);
    await prefs.setStringList(_historyKey, history);
  }

  Future<List<Map<String, dynamic>>> getQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    return history.map((entry) => json.decode(entry) as Map<String, dynamic>).toList()
      ..sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
  }
}