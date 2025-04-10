import "package:flutter/material.dart";
import "package:math_expressions/math_expressions.dart";
//math_expressions: ^2.1.1
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _mainText = TextEditingController();
  final List<String> ops = [
    '1', '2', '3', '+',
    '4', '5', '6', '-',
    '7', '8', '9', '*',
    '0', '/', '←', '='
  ];
  final List<String> functions = [
    'toadd', 'toadd', 'toadd', 'toadd',
    'toadd', 'toadd', 'toadd', 'toadd',
    'toadd', 'toadd', 'toadd', 'toadd',
    'toadd', 'toadd', 'clear', 'calculate',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(40, 42, 137, 110),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(211, 36, 70, 239),
        title: const Center(child: Text('Calculator')),
        elevation: 10,
      ),
      body: Center(
        child: Container(
          height: 510,
          width: 400,
          padding: const EdgeInsets.only(
              left: 20, right: 20, top: 40, bottom: 20),
          decoration: const BoxDecoration(
            color: Color.fromARGB(231, 143, 210, 244),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(127, 49, 81, 243),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _mainText,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    return CalcButton(
                      text: ops[index],
                      mainText: _mainText,
                      pressed: functions[index],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CalcButton extends StatelessWidget {
  final String text;
  final TextEditingController mainText;
  final String pressed;

  const CalcButton({
    super.key,
    required this.text,
    required this.mainText,
    required this.pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
        bottom: 10,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: text == "←"
              ? const Color.fromARGB(255, 240, 136, 128)
              : (text == "="
              ? const Color.fromARGB(255, 123, 242, 127)
              : const Color.fromARGB(255, 234, 234, 234)),
        ),
        onPressed: () {
          if (pressed == "toadd") {
            mainText.text = mainText.text + text;
          } else if (pressed == "clear") {
            if (mainText.text != "") {
              mainText.text =
                  mainText.text.substring(0, mainText.text.length - 1);
            }
          } else if (pressed == "calculate") {
            try {
              Parser p = Parser();
              Expression exp = p.parse(mainText.text);
              ContextModel cm = ContextModel();
              double ans = exp.evaluate(EvaluationType.REAL, cm);
              mainText.text = ans.toString();
            } catch (e) {
              mainText.text = "Invalid Expression";
            }
          }
        },
        child: Text(text),
      ),
    );
  }
}
