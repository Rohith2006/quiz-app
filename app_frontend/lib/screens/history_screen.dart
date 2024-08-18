import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  final QuizService _quizService = QuizService();
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
        title: Text('Quiz History', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizService.getQuizHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: accentColor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No quiz history available.', style: TextStyle(color: accentColor)));
          } else {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final entry = snapshot.data![index];
                      return _buildHistoryCard(entry, index);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> entry, int index) {
    return Hero(
      tag: 'quiz_${entry['id']}',
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showQuizDetails(entry),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['quizName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
                ),
                SizedBox(height: 8),
                Text('Date: ${DateFormat('MMM d, y').format(DateTime.parse(entry['date']))}',
                    style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Score: ${entry['score']}', style: TextStyle(color: Colors.grey[800])),
                    _buildAchievementBadge(entry['score']),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(int score) {
    IconData icon;
    Color color;
    if (score >= 90) {
      icon = Icons.star;
      color = Colors.amber;
    } else if (score >= 70) {
      icon = Icons.thumb_up;
      color = primaryColor;
    } else {
      icon = Icons.emoji_events;
      color = Colors.green;
    }
    return Icon(icon, color: color);
  }

  void _showQuizDetails(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(entry['quizName'], style: TextStyle(color: accentColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${DateFormat('MMMM d, y').format(DateTime.parse(entry['date']))}'),
              SizedBox(height: 8),
              Text('Score: ${entry['score']}'),
              SizedBox(height: 16),
              Text('Congratulations on completing this quiz!', style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: accentColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }
}