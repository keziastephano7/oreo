// main.dart

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Education Ecosystem",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return MainPage();
          } else {
            return LoginPage(); // Dummy Login Page
          }
        },
      ),
    );
  }
}

// Dummy Login Page
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signInAnonymously();
          },
          child: Text("Login (Anonymous)"),
        ),
      ),
    );
  }
}

// ================== WIDGETS AND PAGES ==================

class TextFieldReg extends StatelessWidget {
  final String hinttext;
  final TextEditingController controllertext;
  final bool isObscure;

  TextFieldReg({
    required this.hinttext,
    required this.controllertext,
    required this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controllertext,
        obscureText: isObscure,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hinttext,
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String email;
  final bool user_or_not;

  MessageTile({
    required this.message,
    required this.email,
    required this.user_or_not,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: user_or_not ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: user_or_not ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
          user_or_not ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              email,
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class GroupPage extends StatefulWidget {
  final String groupName;
  GroupPage({super.key, required this.groupName});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late String? userName;
  late String chat_name;
  final TextEditingController msgcontrol = TextEditingController();
  late CollectionReference groupChat;

  @override
  void initState() {
    super.initState();
    userName = FirebaseAuth.instance.currentUser!.email;
    chat_name = widget.groupName;
    groupChat = FirebaseFirestore.instance.collection(chat_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat_name),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 510,
              child: StreamBuilder<QuerySnapshot>(
                stream: groupChat
                    .orderBy("timestamp", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final messageData =
                      documents[index].data() as Map<String, dynamic>;
                      final String message = messageData['message'];
                      final String sender = messageData['sender'];
                      final bool userOr = sender == userName;

                      return MessageTile(
                        message: message,
                        email: sender,
                        user_or_not: userOr,
                      );
                    },
                  );
                },
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter Message",
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    controller: msgcontrol,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (msgcontrol.text.trim().isNotEmpty) {
                      groupChat.add({
                        'message': msgcontrol.text,
                        'sender': userName,
                        'timestamp': DateTime.now(),
                      });
                      msgcontrol.clear();
                    }
                  },
                  child: Text("Send"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final msgController = TextEditingController();
  final emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  void takeTocollabration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupPage(groupName: 'GroupChat')),
    );
  }

  void sendmsg() {
    try {
      String message = msgController.text;
      String toEmail = emailController.text;
      String? fromEmail = currentUser.email;
      Timestamp time = Timestamp.now();

      _firestore.collection('messages').add({
        'content': message,
        'time': time,
        'sender': fromEmail,
        'receiver': toEmail,
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void readMessages() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Messages",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .where('receiver', isEqualTo: currentUser.email)
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text("No messages available.");
                    }
                    var messages = snapshot.data!.docs;
                    List<Widget> messageWidgets = [];
                    for (var message in messages) {
                      var content = message['content'];
                      var sender = message['sender'];
                      messageWidgets.add(
                        ListTile(
                          title: Text(content),
                          subtitle: Text('From: $sender'),
                        ),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      children: messageWidgets,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void sendMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 131, 201, 234),
          body: ListView(
            children: [
              TextFieldReg(
                hinttext: "Enter Message",
                controllertext: msgController,
                isObscure: false,
              ),
              TextFieldReg(
                hinttext: "Enter Email",
                controllertext: emailController,
                isObscure: true,
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: ElevatedButton(
                  onPressed: sendmsg,
                  child: Text("Send"),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 175, 190, 197),
      appBar: AppBar(
        title: Center(child: Text("Education Ecosystem")),
        backgroundColor: Color.fromARGB(255, 151, 227, 240),
        actions: [IconButton(onPressed: logOut, icon: Icon(Icons.logout))],
      ),
      body: Center(child: Text("Logged in as ${currentUser.email ?? 'Anonymous'}")),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 132, 198, 228),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 70),
              Icon(Icons.verified_user, size: 50),
              SizedBox(height: 30),
              GestureDetector(
                onTap: takeTocollabration,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Collabrative Learning"),
                ),
              ),
              Divider(color: Colors.black),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: Text("Send Message"),
                  onTap: sendMessage,
                ),
              ),
              Divider(color: Colors.black),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: Text("Read Messages"),
                  onTap: readMessages,
                ),
              ),
              Divider(color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

// firebase_core: ^2.24.0
// firebase_auth: ^4.16.0
// cloud_firestore: ^4.13.0
