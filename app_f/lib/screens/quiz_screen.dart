import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({required this.quiz});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool showFeedback = false;

  void _checkAnswer(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      showFeedback = true;
      if (selectedIndex == widget.quiz.questions[currentQuestionIndex].correctOptionIndex) {
        score++;
      }
    });

    Future.delayed(Duration(milliseconds: 750), () {
      setState(() {
        if (currentQuestionIndex < widget.quiz.questions.length - 1) {
          currentQuestionIndex++;
          selectedAnswerIndex = null;
          showFeedback = false;
        } else {
          _quizService.saveQuizResult(widget.quiz.name, score);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                quizName: widget.quiz.name,
                score: score,
                totalQuestions: widget.quiz.questions.length,
              ),
            ),
          );
        }
      });
    });
  }

  Color _getOptionColor(int optionIndex) {
    if (showFeedback) {
      if (optionIndex == widget.quiz.questions[currentQuestionIndex].correctOptionIndex) {
        return Colors.green.shade200;
      } else if (optionIndex == selectedAnswerIndex) {
        return Colors.red.shade200;
      }
    }
    return Colors.white;
  }

  IconData? _getOptionIcon(int optionIndex) {
    if (showFeedback) {
      if (optionIndex == widget.quiz.questions[currentQuestionIndex].correctOptionIndex) {
        return Icons.check_circle;
      } else if (optionIndex == selectedAnswerIndex) {
        return Icons.cancel;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.quiz.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'Score: $score/${widget.quiz.questions.length}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Question ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.quiz.questions[currentQuestionIndex].questionText,
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.quiz.questions[currentQuestionIndex].options.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.quiz.questions[currentQuestionIndex].options[index],
                                      style: TextStyle(fontSize: 18.0, color: Colors.black87),
                                    ),
                                  ),
                                  if (_getOptionIcon(index) != null)
                                    Icon(_getOptionIcon(index), color: _getOptionColor(index) == Colors.green.shade200 ? Colors.green : Colors.red),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getOptionColor(index),
                                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: showFeedback ? null : () => _checkAnswer(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}