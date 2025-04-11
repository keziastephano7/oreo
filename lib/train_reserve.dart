import 'package:flutter/material.dart';

void main() => runApp(TicketApp());

class Ticket {
  String name;
  String source;
  String destination;
  int seats;

  Ticket({
    required this.name,
    required this.source,
    required this.destination,
    required this.seats,
  });
}

class TicketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Booking System',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: TicketHomePage(),
    );
  }
}

class TicketHomePage extends StatefulWidget {
  @override
  _TicketHomePageState createState() => _TicketHomePageState();
}

class _TicketHomePageState extends State<TicketHomePage> {
  List<Ticket> tickets = [];

  void _addTicket() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketFormPage(
          onSave: (ticket) {
            setState(() {
              tickets.add(ticket);
            });
          },
        ),
      ),
    );
  }

  void _editTicket(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketFormPage(
          ticket: tickets[index],
          onSave: (updatedTicket) {
            setState(() {
              tickets[index] = updatedTicket;
            });
          },
        ),
      ),
    );
  }

  void _deleteTicket(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel Ticket'),
        content: Text('Are you sure you want to delete this ticket?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                tickets.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(int index) {
    final ticket = tickets[index];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('${ticket.name} - ${ticket.source} → ${ticket.destination}'),
        subtitle: Text('Seats: ${ticket.seats}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _editTicket(index)),
            IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteTicket(index)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Booking System')),
      body: tickets.isEmpty
          ? Center(child: Text('No tickets booked yet.'))
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) => _buildTicketCard(index),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTicket,
        child: Icon(Icons.add),
        tooltip: 'Book Ticket',
      ),
    );
  }
}

class TicketFormPage extends StatefulWidget {
  final Ticket? ticket;
  final Function(Ticket) onSave;

  TicketFormPage({this.ticket, required this.onSave});

  @override
  _TicketFormPageState createState() => _TicketFormPageState();
}

class _TicketFormPageState extends State<TicketFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _source;
  late String _destination;
  late int _seats;

  @override
  void initState() {
    super.initState();
    _name = widget.ticket?.name ?? '';
    _source = widget.ticket?.source ?? '';
    _destination = widget.ticket?.destination ?? '';
    _seats = widget.ticket?.seats ?? 1;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTicket = Ticket(
        name: _name,
        source: _source,
        destination: _destination,
        seats: _seats,
      );
      widget.onSave(newTicket);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ticket != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Ticket' : 'Book Ticket')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Passenger Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _source,
                decoration: InputDecoration(labelText: 'Source'),
                validator: (value) => value!.isEmpty ? 'Enter source' : null,
                onSaved: (value) => _source = value!,
              ),
              TextFormField(
                initialValue: _destination,
                decoration: InputDecoration(labelText: 'Destination'),
                validator: (value) => value!.isEmpty ? 'Enter destination' : null,
                onSaved: (value) => _destination = value!,
              ),
              TextFormField(
                initialValue: _seats.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number of Seats'),
                validator: (value) {
                  final seats = int.tryParse(value ?? '');
                  if (seats == null || seats <= 0) return 'Enter a valid number of seats';
                  return null;
                },
                onSaved: (value) => _seats = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEditing ? 'Update Ticket' : 'Book Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
