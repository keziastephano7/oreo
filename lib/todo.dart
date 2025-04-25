import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  void _addOrEditTask({Todo? todo, int? index}) async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) => TaskDialog(todo: todo),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          todos[index] = result;
        } else {
          todos.add(result);
        }
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blueAccent,
      ),
      body: todos.isEmpty
          ? Center(
        child: Text(
          'No tasks available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    fontSize: 16,
                    fontWeight: todo.isCompleted
                        ? FontWeight.w400
                        : FontWeight.bold,
                    color: todo.isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                leading: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: Colors.blueAccent,
                  value: todo.isCompleted,
                  onChanged: (_) => _toggleTaskCompletion(index),
                ),
                onTap: () => _addOrEditTask(todo: todo, index: index),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteTask(index),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 28),
        backgroundColor: Colors.blueAccent,
        onPressed: () => _addOrEditTask(),
      ),
    );
  }
}

class TaskDialog extends StatefulWidget {
  final Todo? todo;
  TaskDialog({this.todo});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Todo(title: _titleController.text);
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        widget.todo == null ? 'Add Task' : 'Edit Task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Task Title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) => value!.isEmpty ? 'Please enter a task' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Save'),
        ),
      ],
    );
  }
}
