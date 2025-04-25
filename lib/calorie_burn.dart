import 'package:flutter/material.dart';

void main() {
  runApp(CalorieBurnCalculatorApp());
}

class CalorieBurnCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: CalorieBurnCalculatorScreen(),
    );
  }
}

class CalorieBurnCalculatorScreen extends StatefulWidget {
  @override
  _CalorieBurnCalculatorScreenState createState() =>
      _CalorieBurnCalculatorScreenState();
}

class _CalorieBurnCalculatorScreenState
    extends State<CalorieBurnCalculatorScreen> {
  double weight = 60.0;
  String selectedActivity = 'Running';
  double duration = 30.0;
  double caloriesBurned = 0.0;

  final Map<String, double> activityMETs = {
    'Running': 8.0,
    'Walking': 3.5,
    'Cycling': 6.0,
    'Swimming': 7.0,
  };

  void calculateCalories() {
    double metValue = activityMETs[selectedActivity] ?? 3.5;
    setState(() {
      caloriesBurned = (metValue * 3.5 * weight / 200) * duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calorie Burn Calculator"),
        elevation: 4,
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your weight (kg):",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: weight,
                  min: 30,
                  max: 150,
                  divisions: 120,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.orange[100],
                  label: weight.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      weight = value;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${weight.toStringAsFixed(1)} kg",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Select Activity Type:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: DropdownButton<String>(
                    value: selectedActivity,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: activityMETs.keys.map((activity) {
                      return DropdownMenuItem(
                        value: activity,
                        child: Text(
                          activity,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedActivity = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter duration (minutes):",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: duration,
                  min: 5,
                  max: 120,
                  divisions: 23,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.orange[100],
                  label: duration.toStringAsFixed(0),
                  onChanged: (value) {
                    setState(() {
                      duration = value;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${duration.toStringAsFixed(0)} mins",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: calculateCalories,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Calculate",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Calories Burned:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "${caloriesBurned.toStringAsFixed(2)} kcal",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
