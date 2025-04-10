import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _number = TextEditingController();
  String output = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Number Reverser Application")),
        backgroundColor: const Color.fromARGB(255, 179, 60, 235),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(178, 215, 174, 248),
          padding: EdgeInsets.all(10),
          height: 400,
          width: 500,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                child: Text("Enter the Number to Reverse: "),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                padding: EdgeInsets.only(
                  left: 80,
                  right: 80,
                ),
                child: TextField(
                  controller: _number,
                ),
              ),
              GestureDetector(
                onTap: () {
                  int curr = int.parse(_number.text);
                  int ans = 0;
                  while (curr != 0) {
                    ans = (10 * ans) + curr % 10;
                    curr ~/= 10;
                  }
                  setState(() {
                    output = ans.toString();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text("Reverse"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Text("The reversed number is: $output"),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(171, 190, 190, 190),
    );
  }
}
