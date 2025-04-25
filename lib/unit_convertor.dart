import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController valueController = TextEditingController();
  String inputUnit = 'Meters';
  String outputUnit = 'Kilometers';
  double? convertedValue;

  final Map<String, double> lengthConversion = {
    'Meters': 1.0,
    'Kilometers': 0.001,
    'Centimeters': 100.0,
    'Millimeters': 1000.0,
  };

  final Map<String, double> weightConversion = {
    'Kilograms': 1.0,
    'Grams': 1000.0,
    'Pounds': 2.20462,
    'Ounces': 35.274,
  };

  void _convert() {
    double? inputValue = double.tryParse(valueController.text);
    if (inputValue == null) return;

    setState(() {
      if (lengthConversion.containsKey(inputUnit) && lengthConversion.containsKey(outputUnit)) {
        convertedValue = inputValue * (lengthConversion[outputUnit]! / lengthConversion[inputUnit]!);
      } else if (weightConversion.containsKey(inputUnit) && weightConversion.containsKey(outputUnit)) {
        convertedValue = inputValue * (weightConversion[outputUnit]! / weightConversion[inputUnit]!);
      } else {
        convertedValue = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: 'Enter Value',
                    prefixIcon: Icon(Icons.input),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: inputUnit,
                        onChanged: (String? newValue) {
                          setState(() {
                            inputUnit = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'From',
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        items: [...lengthConversion.keys, ...weightConversion.keys]
                            .map<DropdownMenuItem<String>>((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.arrow_forward, size: 24, color: Colors.blueAccent),
                    SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: outputUnit,
                        onChanged: (String? newValue) {
                          setState(() {
                            outputUnit = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'To',
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        items: [...lengthConversion.keys, ...weightConversion.keys]
                            .map<DropdownMenuItem<String>>((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _convert,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Text(
                      'Convert',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                if (convertedValue != null)
                  Text(
                    'Converted Value: ${convertedValue!.toStringAsFixed(2)} $outputUnit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
