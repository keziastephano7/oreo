import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FitnessTrackerScreen(),
    );
  }
}

class FitnessTrackerScreen extends StatefulWidget {
  @override
  _FitnessTrackerScreenState createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  int steps = 5000;
  double caloriesBurned = 200.5;
  List<FlSpot> workoutProgress = [
    FlSpot(1, 2),
    FlSpot(2, 3),
    FlSpot(3, 5),
    FlSpot(4, 7),
    FlSpot(5, 8),
  ];
  double newProgressValue = 5.0;

  void incrementSteps() {
    setState(() {
      steps += 1000;
    });
  }

  void addWorkoutProgress() {
    setState(() {
      workoutProgress.add(FlSpot(workoutProgress.length + 1.toDouble(), newProgressValue));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Tracker")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Daily Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("$steps steps", style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text("Calories Burned:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("$caloriesBurned kcal", style: TextStyle(fontSize: 18)),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: incrementSteps,
                child: Text("Add 1000 steps"),
              ),
              Divider(height: 30),
              Text("Workout Progress:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1.5,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: workoutProgress,
                        isCurved: true,
                        barWidth: 4,
                        color: Colors.blueAccent,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("New Progress Value: ${newProgressValue.toStringAsFixed(1)}"),
              Slider(
                value: newProgressValue,
                min: 0,
                max: 10,
                divisions: 20,
                label: newProgressValue.toStringAsFixed(1),
                onChanged: (val) {
                  setState(() {
                    newProgressValue = val;
                  });
                },
              ),
              ElevatedButton.icon(
                onPressed: addWorkoutProgress,
                icon: Icon(Icons.add_chart),
                label: Text("Add Workout Data Point"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// fl_chart: ^0.66.2
