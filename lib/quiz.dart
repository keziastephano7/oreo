import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: QuizApp()));

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final List<Map<String, dynamic>> questions = [
    {"q": "Flutter is developed by Google?", "a": true},
    {"q": "Dart is used in Flutter?", "a": true},
    {"q": "Flutter is only for Android?", "a": false}
  ];

  int index = 0;
  int score = 0;
  int seconds = 10;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        nextQuestion();
      }
    });
  }

  void checkAnswer(bool answer) {
    if (questions[index]['a'] == answer) {
      score++;
    }
    nextQuestion();
  }

  void nextQuestion() {
    timer.cancel();
    if (index < questions.length - 1) {
      setState(() {
        index++;
        seconds = 10;
      });
      startTimer();
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Over"),
          content: Text("Your Score: $score"),
          actions: [
            TextButton(
              onPressed: resetQuiz,
              child: const Text("Retry"),
            )
          ],
        ),
      );
    }
  }

  void resetQuiz() {
    setState(() {
      index = 0;
      score = 0;
      seconds = 10;
    });
    Navigator.pop(context);
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Time Left: $seconds",
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                questions[index]['q'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => checkAnswer(true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("True"),
                ),
                ElevatedButton(
                  onPressed: () => checkAnswer(false),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("False"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
