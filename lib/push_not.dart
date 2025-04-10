import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// firebase_core: ^2.12.0
// firebase_messaging: ^14.9.0
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token = "";

  @override
  void initState() {
    super.initState();
    setupPushNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Message received in foreground!');
      print('Data: ${message.data}');
      if (message.notification != null) {
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "🔔 ${message.notification!.title}: ${message.notification!.body}",
            ),
          ),
        );
      }
    });
  }

  Future<void> setupPushNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification permission granted");

      // Get FCM token
      String? token = await messaging.getToken();
      setState(() {
        _token = token;
      });
      print("🔑 FCM Token: $token");

      // You can now send this token to your Node.js server if needed
    } else {
      print("❌ Notification permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Notifications App"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("📲 Welcome to the Notifications App"),
              SizedBox(height: 20),
              SelectableText("Your FCM Token:\n$_token"),
            ],
          ),
        ),
      ),
    );
  }
}

// for build gradle
// plugins {
// id 'com.google.gms.google-services' version '4.4.2' apply false
// }

// settings gradle
// plugins {
// id "dev.flutter.flutter-plugin-loader" version "1.0.0"
// id "com.android.application" version "8.1.0" apply false
// id "org.jetbrains.kotlin.android" version "2.1.0" apply false
// }

// /app/build gradle
// plugins {
// id "com.android.application"
// id "kotlin-android"
// id "dev.flutter.flutter-gradle-plugin"
// id 'com.google.gms.google-services'
// }
//
// dependencies {
// implementation platform('com.google.firebase:firebase-bom:33.12.0')
// implementation 'com.google.firebase:firebase-analytics'
// implementation 'com.google.firebase:firebase-messaging'
// }

// /android/app/src/main/AndroidManifest.xml
// <meta-data
// android:name="com.google.firebase.messaging.default_notification_channel_id"
// android:value="default_channel" />
//
// <!-- Permissions -->
// <uses-permission android:name="android.permission.INTERNET"/>
// <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
