import 'package:flutter/material.dart';

void main() => runApp(NoteApp());

class Note {
  String title;
  String content;

  Note({
    required this.title,
    required this.content,
  });
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Making App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: NoteHomePage(),
    );
  }
}

class NoteHomePage extends StatefulWidget {
  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  List<Note> notes = [];

  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(
          onSave: (note) {
            setState(() {
              notes.add(note);
            });
          },
        ),
      ),
    );
  }

  void _editNote(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(
          note: notes[index],
          onSave: (updatedNote) {
            setState(() {
              notes[index] = updatedNote;
            });
          },
        ),
      ),
    );
  }

  Widget _buildNoteCard(int index) {
    final note = notes[index];
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(note.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => _editNote(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: notes.isEmpty
          ? Center(child: Text('No notes yet. Tap + to create one.'))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) => _buildNoteCard(index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
        tooltip: 'Add Note',
      ),
    );
  }
}

class NoteFormPage extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  NoteFormPage({this.note, required this.onSave});

  @override
  _NoteFormPageState createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newNote = Note(title: _title, content: _content);
      widget.onSave(newNote);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 8,
                validator: (value) =>
                value!.isEmpty ? 'Please enter some content' : null,
                onSaved: (value) => _content = value!,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEditing ? 'Update Note' : 'Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
