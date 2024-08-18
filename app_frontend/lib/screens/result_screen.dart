import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String quizName;
  final int score;
  final int totalQuestions;

  ResultScreen({
    required this.quizName,
    required this.score,
    required this.totalQuestions,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ConfettiController _confettiController;

  final Color primaryColor = Color(0xFFAB47BC); // Light Purple
  final Color accentColor = Color(0xFF6A1B9A); // Deep Purple
  final Color backgroundColor = Color.fromARGB(255, 255, 255, 255);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    
    double percentage = widget.score / widget.totalQuestions;
    if (percentage >= 0.7) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String _getResultMessage() {
    double percentage = widget.score / widget.totalQuestions;
    if (percentage >= 0.9) return 'Excellent!';
    if (percentage >= 0.7) return 'Great job!';
    if (percentage >= 0.5) return 'Good effort!';
    return 'Keep practicing!';
  }

  Color _getResultColor() {
    double percentage = widget.score / widget.totalQuestions;
    if (percentage >= 0.9) return Colors.green;
    if (percentage >= 0.7) return Colors.blue;
    if (percentage >= 0.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [backgroundColor, Colors.white],
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _getResultMessage(),
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: _getResultColor()),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Quiz: ${widget.quizName}',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: accentColor),
                  ),
                  SizedBox(height: 20.0),
                  _buildScoreDisplay(),
                  SizedBox(height: 40.0),
                  _buildAchievementBadge(),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                    child: Text('Back to Home', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 30,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
              shouldLoop: false,
              colors: [Colors.blue, Colors.green, Colors.pink, Colors.orange, Colors.purple, Colors.yellow],
              strokeWidth: 1,
              strokeColor: Colors.white,
              particleDrag: 0.05,
              createParticlePath: drawStar,
            ),
          ),
        ],
      ),
    );
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Widget _buildScoreDisplay() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: widget.score / widget.totalQuestions),
      duration: Duration(seconds: 2),
      builder: (BuildContext context, double value, Widget? child) {
        return Column(
          children: [
            Text(
              'Your Score',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: accentColor),
            ),
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 10,
                    backgroundColor: backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(_getResultColor()),
                  ),
                ),
                Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: accentColor),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${widget.score} / ${widget.totalQuestions}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: accentColor),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAchievementBadge() {
    String achievement;
    IconData icon;
    Color color;
    double percentage = widget.score / widget.totalQuestions;
    if (percentage >= 0.9) {
      achievement = 'Gold';
      icon = Icons.star;
      color = Colors.yellow[700]!;
    } else if (percentage >= 0.7) {
      achievement = 'Silver';
      icon = Icons.star_half;
      color = Colors.grey[400]!;
    } else if (percentage >= 0.5) {
      achievement = 'Bronze';
      icon = Icons.star_border;
      color = Colors.brown[400]!;
    } else {
      achievement = 'Participant';
      icon = Icons.emoji_events_outlined;
      color = Colors.blue[300]!;
    }

    return Column(
      children: [
        Icon(icon, size: 60, color: color),
        SizedBox(height: 10),
        Text(
          achievement,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}