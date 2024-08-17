import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';
import '../widgets/option_button.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({required this.quiz});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final QuizService _quizService = QuizService();
  int currentQuestionIndex = 0;
  int score = 0;
  bool? isCorrect;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer(int selectedIndex) {
    setState(() {
      isCorrect = selectedIndex ==
          widget.quiz.questions[currentQuestionIndex].correctOptionIndex;
      score += isCorrect! ? 1 : 0;
      _animationController.forward(from: 0.0);
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (currentQuestionIndex < widget.quiz.questions.length - 1) {
          currentQuestionIndex++;
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
        isCorrect = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.quiz.questions[currentQuestionIndex].questionText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ...widget.quiz.questions[currentQuestionIndex].options
                .asMap()
                .entries
                .map((entry) {
              return OptionButton(
                text: entry.value,
                onPressed: isCorrect == null
                    ? () => _checkAnswer(entry.key)
                    : null,
              );
            }).toList(),
            SizedBox(height: 20.0),
            if (isCorrect != null)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Icon(
                      isCorrect! ? Icons.check_circle : Icons.cancel,
                      color: isCorrect! ? Colors.green : Colors.red,
                      size: 80.0,
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