import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Counter Application",
      debugShowCheckedModeBanner: false,
      home: OctalCounter(),
    );
  }
}

// Octal Counter
class OctalCounter extends StatefulWidget {
  const OctalCounter({super.key});

  @override
  State<OctalCounter> createState() => _OctalCounterState();
}

class _OctalCounterState extends State<OctalCounter> {
  var counter = 0;

  void incrementOctal() {
    setState(() {
      counter = (counter + 1) % 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Octal Counter")),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color.fromARGB(96, 61, 224, 142),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(counter.toString()),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: incrementOctal,
              child: Text("Increment"),
            ),
          ],
        ),
      ),
      drawer: CounterDrawer(),
    );
  }
}

// Decimal Counter
class DecimalCounter extends StatefulWidget {
  const DecimalCounter({super.key});

  @override
  State<DecimalCounter> createState() => _DecimalCounterState();
}

class _DecimalCounterState extends State<DecimalCounter> {
  var counter = 0;

  void incrementDecimal() {
    setState(() {
      counter = (counter + 1) % 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Decimal Counter")),
        backgroundColor: const Color.fromARGB(255, 46, 173, 88),
      ),
      backgroundColor: const Color.fromARGB(95, 30, 255, 0),
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 136, 201, 226),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                counter.toString(),
                style: TextStyle(fontSize: 15, color: Colors.purple),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: incrementDecimal,
                child: Text("Increment"),
              ),
            ],
          ),
        ),
      ),
      drawer: CounterDrawer(),
    );
  }
}

// Hexadecimal Counter
class hexCounter extends StatefulWidget {
  const hexCounter({super.key});

  @override
  State<hexCounter> createState() => _hexCounterState();
}

class _hexCounterState extends State<hexCounter> {
  var counter = 0;
  String dispString = "0";

  void incrementHexadecimal() {
    setState(() {
      counter = (counter + 1) % 16;
      switch (counter) {
        case 10:
          dispString = "A";
          break;
        case 11:
          dispString = "B";
          break;
        case 12:
          dispString = "C";
          break;
        case 13:
          dispString = "D";
          break;
        case 14:
          dispString = "E";
          break;
        case 15:
          dispString = "F";
          break;
        default:
          dispString = counter.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Hexadecimal Counter")),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color.fromARGB(96, 61, 224, 142),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dispString),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: incrementHexadecimal,
              child: Text("Increment"),
            ),
          ],
        ),
      ),
      drawer: CounterDrawer(),
    );
  }
}

// Drawer with Navigation
class CounterDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: 120),
          Icon(Icons.chat_bubble_outline_sharp),
          SizedBox(height: 120),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OctalCounter()));
            },
            child: Text("Octal Counter"),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DecimalCounter()));
            },
            child: Text("Decimal Counter"),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => hexCounter()));
            },
            child: Text("Hexadecimal Counter"),
          ),
        ],
      ),
    );
  }
}
