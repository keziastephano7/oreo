import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// http: ^0.13.6
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple HTTP Movie App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _movies = [];
  final TextEditingController _count = TextEditingController();

  Future<void> fetchMovies(int count) async {
    final url = Uri.parse('https://www.freetestapi.com/api/v1/movies?limit=$count');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _movies = data;
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Ratings'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _count,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter number of movies",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      final int count = int.tryParse(_count.text) ?? 0;
                      if (count > 0) {
                        fetchMovies(count);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text("Show"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _movies.isEmpty
                  ? const Center(child: Text('No movies loaded yet.'))
                  : ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(movie["title"]),
                      subtitle: Text("Rating: ${movie["rating"]}"),
                      trailing: Text("Year: ${movie["year"]}"),
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
