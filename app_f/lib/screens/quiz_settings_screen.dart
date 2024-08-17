import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class QuizSettingsScreen extends StatefulWidget {
  @override
  _QuizSettingsScreenState createState() => _QuizSettingsScreenState();
}

class _QuizSettingsScreenState extends State<QuizSettingsScreen> {
  int _numberOfQuestions = 10;
  String _difficulty = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Number of Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _numberOfQuestions.toDouble(),
              min: 5,
              max: 40,
              divisions: 7,
              activeColor: Colors.blue, // Add the activeColor property
              label: _numberOfQuestions.toString(),
              onChanged: (double value) {
                setState(() {
                  _numberOfQuestions = value.round();
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Difficulty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _difficulty,
              isExpanded: true,
              items: <String>['Easy', 'Medium', 'Hard']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _difficulty = newValue!;
                });
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text('Start Quiz'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      numberOfQuestions: _numberOfQuestions,
                      difficulty: _difficulty,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}