import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../services/quiz_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final String difficulty;

  QuizScreen({required this.numberOfQuestions, required this.difficulty});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  late Future<List<Question>> _questionsFuture;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool showFeedback = false;
  bool hintVisible = false; // Track hint visibility

  @override
  void initState() {
    super.initState();
    _questionsFuture = _fetchQuestions();
  }

  Future<List<Question>> _fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://go-server-theta.vercel.app/get-random-questions?difficulty=${widget.difficulty.toLowerCase()}&num=${widget.numberOfQuestions}'));

    if (response.statusCode == 200) {
      List<dynamic> questionsJson = json.decode(response.body);
      return questionsJson.map((q) => Question.fromJson(q)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _checkAnswer(Question question, int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      showFeedback = true;
      if (selectedIndex == question.correctOptionIndex) {
        score++;
      }
    });

    Future.delayed(Duration(milliseconds: 750), () {
      setState(() {
        if (currentQuestionIndex < widget.numberOfQuestions - 1) {
          currentQuestionIndex++;
          selectedAnswerIndex = null;
          showFeedback = false;
          hintVisible = false; // Reset hint visibility
        } else {
          _quizService.saveQuizResult('${widget.difficulty} Quiz', score);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                quizName: '${widget.difficulty} Quiz',
                score: score,
                totalQuestions: widget.numberOfQuestions,
              ),
            ),
          );
        }
      });
    });
  }

  void _revealHint() {
    setState(() {
      hintVisible = true;
    });
  }

  void _exitQuiz() {
    Navigator.pop(context);
  }

  Color _getOptionColor(Question question, int optionIndex) {
    if (showFeedback) {
      if (optionIndex == question.correctOptionIndex) {
        return Colors.green.shade200;
      } else if (optionIndex == selectedAnswerIndex) {
        return Colors.red.shade200;
      }
    }
    return Colors.white;
  }

  IconData? _getOptionIcon(Question question, int optionIndex) {
    if (showFeedback) {
      if (optionIndex == question.correctOptionIndex) {
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
        child: FutureBuilder<List<Question>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No questions available'));
            }

            List<Question> questions = snapshot.data!;
            Question currentQuestion = questions[currentQuestionIndex];

            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.difficulty} Quiz',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Score: $score/${widget.numberOfQuestions}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / widget.numberOfQuestions,
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
                              'Question ${currentQuestionIndex + 1}/${widget.numberOfQuestions}',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              currentQuestion.question,
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20.0),
                            if (hintVisible)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  'Hint: ${currentQuestion.hint}',
                                  style: TextStyle(fontSize: 18.0, color: Colors.blue),
                                ),
                              ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: currentQuestion.options.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              currentQuestion.options[index],
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                          if (_getOptionIcon(
                                                  currentQuestion, index) !=
                                              null)
                                            Icon(
                                                _getOptionIcon(
                                                    currentQuestion, index),
                                                color: _getOptionColor(
                                                            currentQuestion,
                                                            index) ==
                                                        Colors.green.shade200
                                                    ? Colors.green
                                                    : Colors.red),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _getOptionColor(currentQuestion, index),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: showFeedback
                                          ? null
                                          : () =>
                                              _checkAnswer(currentQuestion, index),
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
                Positioned(
                  bottom: 72, // Adjust bottom space for better spacing
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: _revealHint,
                    child: Text('Show Hint'),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: _exitQuiz,
                    child: Text('Exit Quiz'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
