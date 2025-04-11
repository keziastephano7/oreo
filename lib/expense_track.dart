import 'package:flutter/material.dart';

void main() => runApp(BudgetApp());

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Manager',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  @override
  _BudgetHomePageState createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  final _formKey = GlobalKey<FormState>();
  double income = 0;
  double expenses = 0;
  double savingGoal = 0;

  double get savings => income - expenses;
  double get progress => savingGoal == 0 ? 0 : (savings / savingGoal).clamp(0, 1);

  final TextEditingController incomeCtrl = TextEditingController();
  final TextEditingController expenseCtrl = TextEditingController();
  final TextEditingController goalCtrl = TextEditingController();

  void _calculateBudget() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        income = double.tryParse(incomeCtrl.text) ?? 0;
        expenses = double.tryParse(expenseCtrl.text) ?? 0;
        savingGoal = double.tryParse(goalCtrl.text) ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Budget Manager')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: incomeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Monthly Income'),
                  validator: (val) => val!.isEmpty ? 'Enter income' : null,
                ),
                TextFormField(
                  controller: expenseCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Total Expenses'),
                  validator: (val) => val!.isEmpty ? 'Enter expenses' : null,
                ),
                TextFormField(
                  controller: goalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Saving Goal'),
                  validator: (val) => val!.isEmpty ? 'Enter saving goal' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateBudget,
                  child: Text('Calculate'),
                ),
              ]),
            ),
            SizedBox(height: 30),
            if (income > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Savings: ₹${savings.toStringAsFixed(2)}'),
                  Text('Goal: ₹${savingGoal.toStringAsFixed(2)}'),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                  SizedBox(height: 5),
                  Text('${(progress * 100).toStringAsFixed(1)}% of goal reached'),
                ],
              )
          ],
        ),
      ),
    );
  }
}
