import 'package:flutter/material.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AboutPage(),
    ProjectsPage(),
    BlogPage(),
    ContactPage(),
  ];

  final List<String> _titles = const [
    'About',
    'Projects',
    'Blog',
    'Contact',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Blog'),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Contact'),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey("about"),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Hello! I am a passionate developer focused on building clean, user-friendly apps.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey("projects"),
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.code),
          title: Text('Project One'),
          subtitle: Text('A cross-platform mobile app.'),
        ),
        ListTile(
          leading: Icon(Icons.code),
          title: Text('Project Two'),
          subtitle: Text('A web application built with modern frameworks.'),
        ),
      ],
    );
  }
}

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey("blog"),
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          title: Text('Why I Love Flutter'),
          subtitle: Text('Posted on Jan 1, 2025'),
        ),
        ListTile(
          title: Text('Productivity Tips for Devs'),
          subtitle: Text('Posted on Feb 14, 2025'),
        ),
      ],
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey("contact"),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.email, size: 48),
            SizedBox(height: 10),
            Text('contact@example.com', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
