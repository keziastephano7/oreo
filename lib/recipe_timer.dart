import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(RecipeTimerApp());
}

class RecipeTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RecipeTimerScreen(),
    );
  }
}

class RecipeTimerScreen extends StatefulWidget {
  @override
  _RecipeTimerScreenState createState() => _RecipeTimerScreenState();
}

class _RecipeTimerScreenState extends State<RecipeTimerScreen> {
  final TextEditingController _timeController = TextEditingController();
  int _remainingTime = 0; // in seconds
  Timer? _timer;
  bool _isTimerRunning = false;

  void startTimer() {
    int duration = int.parse(_timeController.text) * 60; // Convert minutes to seconds
    setState(() {
      _remainingTime = duration;
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Timer"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter Cooking Time (in minutes):",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Cooking Time in Minutes',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isTimerRunning ? null : startTimer,
              child: Text(_isTimerRunning ? "Timer Running" : "Start Timer"),
            ),
            SizedBox(height: 40),
            if (_isTimerRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: 50, color: Colors.green),
                  SizedBox(width: 20),
                  Text(
                    formatTime(_remainingTime),
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (!_isTimerRunning && _remainingTime > 0)
              Text(
                "Timer Finished!",
                style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
  
