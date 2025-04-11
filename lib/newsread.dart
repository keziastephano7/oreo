import 'package:flutter/material.dart';

void main() => runApp(NewsApp());

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: NewsHomePage(),
    );
  }
}

class NewsHomePage extends StatelessWidget {
  final List<Map<String, String>> news = [
    {
      'title': 'Flutter 3.10 Released!',
      'description': 'Flutter 3.10 includes new rendering engine upgrades, better performance, and cross-platform capabilities.'
    },
    {
      'title': 'AI Changes the World',
      'description': 'AI is revolutionizing industries from healthcare to transportation. Experts predict major transformations.'
    },
    {
      'title': 'SpaceX Launch Success',
      'description': 'SpaceX successfully launched a satellite into orbit, marking another milestone in private space exploration.'
    },
    {
      'title': 'New iPhone Unveiled',
      'description': 'Apple unveiled the new iPhone with advanced camera tech, better battery life, and a sleek design.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Headlines')),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(news[index]['title']!),
            leading: Icon(Icons.article_outlined),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(
                    title: news[index]['title']!,
                    description: news[index]['description']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String description;

  NewsDetailPage({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
