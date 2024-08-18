import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiz_settings_screen.dart';
import 'history_screen.dart';
import 'dart:math' as math;
import '/services/quiz_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _totalQuizzesTaken = 0;
  final QuizService _quizService = QuizService();

  final Color primaryColor = Color(0xFFAB47BC); // Light Purple
  final Color accentColor = Color(0xFF6A1B9A); // Deep Purple
  final Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _fetchQuizHistory();
  }

  void _fetchQuizHistory() async {
    final history = await _quizService.getQuizHistory();
    setState(() {
      _totalQuizzesTaken = history.length;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Master', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundColor, Colors.white],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * math.pi,
                      child: child,
                    );
                  },
                  child: Icon(Icons.quiz, size: 80, color: accentColor),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to Quiz Master',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: accentColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Test your knowledge and have fun!',
                  style: TextStyle(fontSize: 16, color: primaryColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildAnimatedButton(
                  'Start Quiz',
                  Icons.play_arrow,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizSettingsScreen())),
                ),
                SizedBox(height: 20),
                _buildAnimatedButton(
                  'View History',
                  Icons.history,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HistoryScreen())),
                ),
                SizedBox(height: 40),
                _buildQuizStatistics(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(
      String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 18)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 3,
      ),
      onPressed: onPressed,
    );
  }

Widget _buildQuizStatistics() {
  return AnimatedOpacity(
    opacity: _totalQuizzesTaken > 0 ? 1.0 : 0.0,
    duration: Duration(seconds: 1),
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 238), // Background color
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 2, // How much the shadow spreads
            blurRadius: 5, // How blurry the shadow is
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Quizzes Taken',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A), // Accent color
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$_totalQuizzesTaken',
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFFAB47BC), // Accent color
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


}
