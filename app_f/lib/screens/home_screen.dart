import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import 'quiz_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  final QuizService _quizService = QuizService();

  @override
  Widget build(BuildContext context) {
    final quizzes = _quizService.getQuizzes();

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Available Quizzes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...quizzes.map((quiz) => Card(
            child: ListTile(
              title: Text(quiz.name),
              trailing: Icon(Icons.arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen(quiz: quiz)),
              ),
            ),
          )).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('View History'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            ),
          ),
        ],
      ),
    );
  }
}