import 'package:flutter/material.dart';

void main() {
  runApp(LibraryManagementApp());
}

class LibraryManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LibraryManagementScreen(),
    );
  }
}

class LibraryManagementScreen extends StatefulWidget {
  @override
  _LibraryManagementScreenState createState() => _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  List<Book> _books = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  void _addBook() {
    if (_titleController.text.isNotEmpty &&
        _authorController.text.isNotEmpty &&
        _yearController.text.isNotEmpty) {
      setState(() {
        _books.add(Book(
          title: _titleController.text,
          author: _authorController.text,
          year: int.parse(_yearController.text),
        ));
      });
      _clearFields();
    }
  }

  void _editBook(int index) {
    _titleController.text = _books[index].title;
    _authorController.text = _books[index].author;
    _yearController.text = _books[index].year.toString();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Book'),
        content: Column(
          children: [
            _buildTextField(_titleController, 'Book Title'),
            _buildTextField(_authorController, 'Author'),
            _buildTextField(_yearController, 'Year of Publication'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _books[index] = Book(
                  title: _titleController.text,
                  author: _authorController.text,
                  year: int.parse(_yearController.text),
                );
              });
              _clearFields();
              Navigator.of(ctx).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteBook(int index) {
    setState(() {
      _books.removeAt(index);
    });
  }

  void _clearFields() {
    _titleController.clear();
    _authorController.clear();
    _yearController.clear();
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library Management System"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_titleController, 'Book Title'),
            _buildTextField(_authorController, 'Author'),
            _buildTextField(_yearController, 'Year of Publication'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addBook,
              child: Text("Add Book"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(height: 20),
            Text(
              'Library Books',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: ListTile(
                      title: Text(_books[index].title),
                      subtitle: Text('by ${_books[index].author}, ${_books[index].year}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editBook(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteBook(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final int year;

  Book({
    required this.title,
    required this.author,
    required this.year,
  });
}
