import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class QuizService {
  static const String _historyKey = 'quiz_history';

  List<Quiz> getQuizzes() {
  return [
    Quiz(
      name: 'General Knowledge',
      questions: [
        Question(
          questionText: 'What is the capital of France?',
          options: ['London', 'Berlin', 'Paris', 'Madrid'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Who painted the Mona Lisa?',
          options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Rembrandt'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'What is the largest planet in our solar system?',
          options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'In which year did World War II end?',
          options: ['1943', '1945', '1947', '1950'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'What is the chemical symbol for gold?',
          options: ['Au', 'Ag', 'Fe', 'Cu'],
          correctOptionIndex: 0,
        ),
      ],
    ),
    Quiz(
      name: 'Science',
      questions: [
        Question(
          questionText: 'What is the chemical symbol for water?',
          options: ['Wa', 'H2O', 'O2', 'CO2'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'What planet is known as the Red Planet?',
          options: ['Venus', 'Jupiter', 'Mars', 'Saturn'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'What is the hardest natural substance on Earth?',
          options: ['Gold', 'Iron', 'Diamond', 'Platinum'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'What is the largest organ in the human body?',
          options: ['Heart', 'Brain', 'Liver', 'Skin'],
          correctOptionIndex: 3,
        ),
        Question(
          questionText: 'Which of these is not a state of matter?',
          options: ['Solid', 'Liquid', 'Gas', 'Rock'],
          correctOptionIndex: 3,
        ),
      ],
    ),
    Quiz(
      name: 'History',
      questions: [
        Question(
          questionText: 'Who was the first President of the United States?',
          options: ['Thomas Jefferson', 'John Adams', 'George Washington', 'Benjamin Franklin'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'In which year did Christopher Columbus first reach the Americas?',
          options: ['1492', '1500', '1512', '1525'],
          correctOptionIndex: 0,
        ),
        Question(
          questionText: 'Which ancient wonder was located in Alexandria?',
          options: ['Hanging Gardens', 'Colossus', 'Lighthouse', 'Great Pyramid'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Who was the first woman to win a Nobel Prize?',
          options: ['Marie Curie', 'Mother Teresa', 'Jane Addams', 'Bertha von Suttner'],
          correctOptionIndex: 0,
        ),
        Question(
          questionText: 'In which year did the Berlin Wall fall?',
          options: ['1987', '1989', '1991', '1993'],
          correctOptionIndex: 1,
        ),
      ],
    ),
    Quiz(
      name: 'Literature',
      questions: [
        Question(
          questionText: 'Who wrote "Romeo and Juliet"?',
          options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'What is the name of the hobbit in "The Lord of the Rings"?',
          options: ['Bilbo', 'Frodo', 'Sam', 'Pippin'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'Who wrote "1984"?',
          options: ['George Orwell', 'Aldous Huxley', 'Ray Bradbury', 'H.G. Wells'],
          correctOptionIndex: 0,
        ),
        Question(
          questionText: 'Which of these is not a work by Jane Austen?',
          options: ['Pride and Prejudice', 'Emma', 'Sense and Sensibility', 'Wuthering Heights'],
          correctOptionIndex: 3,
        ),
        Question(
          questionText: 'Who wrote "The Catcher in the Rye"?',
          options: ['F. Scott Fitzgerald', 'Ernest Hemingway', 'J.D. Salinger', 'John Steinbeck'],
          correctOptionIndex: 2,
        ),
      ],
    ),
    Quiz(
      name: 'Geography',
      questions: [
        Question(
          questionText: 'What is the largest country by land area?',
          options: ['China', 'USA', 'Canada', 'Russia'],
          correctOptionIndex: 3,
        ),
        Question(
          questionText: 'Which of these is not a continent?',
          options: ['Europe', 'Australia', 'Antarctica', 'Greenland'],
          correctOptionIndex: 3,
        ),
        Question(
          questionText: 'What is the capital of Brazil?',
          options: ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Which desert is the largest in the world?',
          options: ['Gobi', 'Kalahari', 'Sahara', 'Antarctic'],
          correctOptionIndex: 3,
        ),
        Question(
          questionText: 'What is the longest river in the world?',
          options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
          correctOptionIndex: 1,
        ),
      ],
    ),
    Quiz(
      name: 'Movies',
      questions: [
        Question(
          questionText: 'Who directed the movie "Jaws"?',
          options: ['Steven Spielberg', 'Martin Scorsese', 'Francis Ford Coppola', 'George Lucas'],
          correctOptionIndex: 0,
        ),
        Question(
          questionText: 'Which movie won the Oscar for Best Picture in 2020?',
          options: ['1917', 'Joker', 'Parasite', 'Once Upon a Time in Hollywood'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Who played Jack in the movie "Titanic"?',
          options: ['Brad Pitt', 'Leonardo DiCaprio', 'Johnny Depp', 'Tom Cruise'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'Which of these is not a Marvel superhero?',
          options: ['Iron Man', 'Captain America', 'Batman', 'Thor'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Who played Hermione Granger in the Harry Potter films?',
          options: ['Emma Watson', 'Emma Stone', 'Emma Roberts', 'Emily Blunt'],
          correctOptionIndex: 0,
        ),
      ],
    ),
    Quiz(
      name: 'Music',
      questions: [
        Question(
          questionText: 'Who is known as the "King of Pop"?',
          options: ['Elvis Presley', 'Michael Jackson', 'Prince', 'David Bowie'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'Which band performed the song "Bohemian Rhapsody"?',
          options: ['The Beatles', 'Led Zeppelin', 'Queen', 'Pink Floyd'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'What instrument does Yo-Yo Ma play?',
          options: ['Violin', 'Piano', 'Cello', 'Flute'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Who wrote the opera "The Magic Flute"?',
          options: ['Bach', 'Beethoven', 'Mozart', 'Tchaikovsky'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Which of these is not a type of guitar?',
          options: ['Acoustic', 'Electric', 'Bass', 'Soprano'],
          correctOptionIndex: 3,
        ),
      ],
    ),
    Quiz(
      name: 'Sports',
      questions: [
        Question(
          questionText: 'In which sport would you perform a slam dunk?',
          options: ['Football', 'Tennis', 'Basketball', 'Golf'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'How many players are there in a soccer team on the field?',
          options: ['9', '10', '11', '12'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'Which country has won the most FIFA World Cups?',
          options: ['Germany', 'Italy', 'Argentina', 'Brazil'],
          correctOptionIndex: 3,
        ),
        Question(
          questionText: 'In which sport is the Davis Cup awarded?',
          options: ['Tennis', 'Cricket', 'Rugby', 'Ice Hockey'],
          correctOptionIndex: 0,
        ),
        Question(
          questionText: 'How many Olympic rings are there?',
          options: ['4', '5', '6', '7'],
          correctOptionIndex: 1,
        ),
      ],
    ),
    Quiz(
      name: 'Technology',
      questions: [
        Question(
          questionText: 'Who is the co-founder of Microsoft?',
          options: ['Steve Jobs', 'Bill Gates', 'Mark Zuckerberg', 'Jeff Bezos'],
          correctOptionIndex: 1,
        ),
        Question(
          questionText: 'What does "CPU" stand for?',
          options: ['Central Processing Unit', 'Computer Personal Unit', 'Central Process Unit', 'Central Processor Unit'],
          correctOptionIndex: 0,
        ),
        Question(
          questionText: 'Which company developed the iPhone?',
          options: ['Google', 'Samsung', 'Apple', 'Microsoft'],
          correctOptionIndex: 2,
        ),
        Question(
          questionText: 'What does "WWW" stand for in a website browser?',
          options: ['World Wide Web', 'World War Web', 'Wide World Web', 'Web World Wide'],
          correctOptionIndex: 0,
        ),
        Question(
          questionText: 'Which of these is not a programming language?',
          options: ['Java', 'Python', 'Ruby', 'Photoshop'],
          correctOptionIndex: 3,
        ),
      ],
    ),
  ];
}

  Future<void> saveQuizResult(String quizName, int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    final newEntry = json.encode({
      'date': DateTime.now().toIso8601String(),
      'quizName': quizName,
      'score': score,
    });
    
    history.add(newEntry);
    await prefs.setStringList(_historyKey, history);
  }

  Future<List<Map<String, dynamic>>> getQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    return history.map((entry) => json.decode(entry) as Map<String, dynamic>).toList()
      ..sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
  }
}