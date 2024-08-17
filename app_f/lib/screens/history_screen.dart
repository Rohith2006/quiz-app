import 'package:flutter/material.dart';
import '../services/quiz_service.dart';

class HistoryScreen extends StatelessWidget {
  final QuizService _quizService = QuizService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizService.getQuizHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quiz history available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final entry = snapshot.data![index];
                return ListTile(
                  title: Text(entry['quizName']),
                  subtitle: Text('Date: ${DateTime.parse(entry['date']).toLocal()}'),
                  trailing: Text('Score: ${entry['score']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}