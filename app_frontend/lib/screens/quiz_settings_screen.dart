import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class QuizSettingsScreen extends StatefulWidget {
  @override
  _QuizSettingsScreenState createState() => _QuizSettingsScreenState();
}

class _QuizSettingsScreenState extends State<QuizSettingsScreen> with SingleTickerProviderStateMixin {
  int _numberOfQuestions = 10;
  String _difficulty = 'Medium';
  late AnimationController _controller;
  late Animation<double> _animation;

  final Color primaryColor = Color(0xFFAB47BC); // Light Purple
  final Color accentColor = Color(0xFF6A1B9A); // Deep Purple
  final Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
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
        title: Text('Quiz Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, Colors.white],
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSettingCard(
                  title: 'Number of Questions',
                  child: Column(
                    children: [
                      Slider(
                        value: _numberOfQuestions.toDouble(),
                        min: 5,
                        max: 40,
                        divisions: 7,
                        activeColor: primaryColor,
                        label: _numberOfQuestions.toString(),
                        onChanged: (double value) {
                          setState(() {
                            _numberOfQuestions = value.round();
                          });
                        },
                      ),
                      Text(
                        '${_numberOfQuestions.toString()} Questions',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accentColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildSettingCard(
                  title: 'Difficulty',
                  child: DropdownButton<String>(
                    value: _difficulty,
                    isExpanded: true,
                    dropdownColor: backgroundColor,
                    items: <String>['Easy', 'Medium', 'Hard']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: accentColor)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _difficulty = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 40),
                _buildStartQuizButton(),
                SizedBox(height: 20),
                _buildDifficultyInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({required String title, required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStartQuizButton() {
    return ElevatedButton(
      child: Text('Start Quiz', style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 3,
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
    );
  }

  Widget _buildDifficultyInfo() {
    return AnimatedOpacity(
      opacity: _difficulty == 'Hard' ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Card(
        color: Colors.orange[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange[800]),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hard difficulty selected! Are you ready for a challenge?',
                  style: TextStyle(color: Colors.orange[800]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}