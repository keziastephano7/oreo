import 'package:flutter/material.dart';

void main() => runApp(EmployeeApp());

class Employee {
  String name;
  String role;
  Employee({required this.name, required this.role});
}

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Manager',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: EmployeeHomePage(),
    );
  }
}

class EmployeeHomePage extends StatefulWidget {
  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  List<Employee> employees = [];

  void _addOrEdit({Employee? emp, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeForm(
          employee: emp,
          onSave: (newEmp) {
            setState(() {
              if (index == null) {
                employees.add(newEmp);
              } else {
                employees[index] = newEmp;
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Management')),
      body: employees.isEmpty
          ? Center(child: Text('No employees added yet.'))
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final emp = employees[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(emp.name),
                    subtitle: Text(emp.role),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.edit), onPressed: () => _addOrEdit(emp: emp, index: index)),
                        IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteEmployee(index)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEdit(),
        child: Icon(Icons.add),
        tooltip: 'Add Employee',
      ),
    );
  }
}

class EmployeeForm extends StatefulWidget {
  final Employee? employee;
  final Function(Employee) onSave;

  EmployeeForm({this.employee, required this.onSave});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _role;

  @override
  void initState() {
    super.initState();
    _name = widget.employee?.name ?? '';
    _role = widget.employee?.role ?? '';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave(Employee(name: _name, role: _role));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                initialValue: _role,
                decoration: InputDecoration(labelText: 'Role'),
                validator: (val) => val!.isEmpty ? 'Enter a role' : null,
                onSaved: (val) => _role = val!,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
