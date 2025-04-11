import 'package:flutter/material.dart';

void main() {
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: EventListPage(),
    );
  }
}

class Event {
  String name;
  String description;
  String date;

  Event({required this.name, required this.description, required this.date});
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Event> events = [];

  void _addEvent() async {
    final newEvent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventFormPage()),
    );

    if (newEvent != null && newEvent is Event) {
      setState(() {
        events.add(newEvent);
      });
    }
  }

  void _editEvent(int index) async {
    final editedEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventFormPage(event: events[index]),
      ),
    );

    if (editedEvent != null && editedEvent is Event) {
      setState(() {
        events[index] = editedEvent;
      });
    }
  }

  void _deleteEvent(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Event'),
        content: Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                events.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Management')),
      body: events.isEmpty
          ? Center(child: Text('No events yet. Tap + to add one!'))
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.name),
            subtitle: Text('${event.date} - ${event.description}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editEvent(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteEvent(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      ),
    );
  }
}

class EventFormPage extends StatefulWidget {
  final Event? event;

  EventFormPage({this.event});

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late String date;

  @override
  void initState() {
    super.initState();
    name = widget.event?.name ?? '';
    description = widget.event?.description ?? '';
    date = widget.event?.date ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context,
          Event(name: name.trim(), description: description.trim(), date: date.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Event Name'),
                onChanged: (val) => name = val,
                validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (val) => description = val,
                validator: (val) => val == null || val.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                initialValue: date,
                decoration: InputDecoration(labelText: 'Date (e.g., 2025-04-11)'),
                onChanged: (val) => date = val,
                validator: (val) => val == null || val.isEmpty ? 'Enter date' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.event == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
