import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// shared_preferences: ^2.0.0
void main() {
  runApp(DailyJournalApp());
}

class DailyJournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: JournalScreen(),
    );
  }
}

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _entries = prefs.getStringList('journalEntries') ?? [];
    });
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('journalEntries', _entries);
  }

  void _addEntry() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _entries.insert(0, _controller.text.trim());
        _controller.clear();
      });
      _saveEntries();
    }
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
    _saveEntries();
  }

  void _editEntry(int index) {
    final TextEditingController editController =
        TextEditingController(text: _entries[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Entry'),
        content: TextField(
          controller: editController,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Edit your thoughts...',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _entries[index] = editController.text.trim();
                });
                _saveEntries();
                Navigator.pop(context);
              },
              child: Text('Save')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('📝 Daily Journal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Write your thoughts...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addEntry,
              icon: Icon(Icons.add),
              label: Text('Add Entry'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _entries.isEmpty
                  ? Center(
                      child: Text(
                        'No journal entries yet.',
                        style: theme.textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(
                              _entries[index],
                              style: theme.textTheme.bodyLarge,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Edit',
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editEntry(index),
                                ),
                                IconButton(
                                  tooltip: 'Delete',
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteEntry(index),
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
