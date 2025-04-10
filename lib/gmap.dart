import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? tappedLocation;

  void _onMapTapped(LatLng position) {
    setState(() {
      tappedLocation = position;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tapped: ${position.latitude}, ${position.longitude}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tap to Get Coordinates'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(20.5937, 78.9629), // Center of India
          zoom: 5,
        ),
        onMapCreated: (controller) => mapController = controller,
        onTap: _onMapTapped,
        markers: tappedLocation != null
            ? {
          Marker(
            markerId: MarkerId('tapped'),
            position: tappedLocation!,
          )
        }
            : {},
      ),
    );
  }
}

// dependencies:
// flutter:
// sdk: flutter
// cupertino_icons: ^1.0.8
// google_maps_flutter: ^2.6.0
// location: ^5.0.3

// <manifest xmlns:android="http://schemas.android.com/apk/res/android"
// package="com.example.gmaps_app">
//
// <!-- Permissions -->
// <uses-permission android:name="android.permission.INTERNET" />
// <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
// <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
//
// <application
// android:label="mapsapp"
// android:name="${applicationName}"
// android:icon="@mipmap/ic_launcher">
//
// <!-- Main Activity -->
// <activity
// android:name=".MainActivity"
// android:exported="true"
// android:launchMode="singleTop"
// android:taskAffinity=""
// android:theme="@style/LaunchTheme"
// android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
// android:hardwareAccelerated="true"
// android:windowSoftInputMode="adjustResize">
//
// <!-- Specifies an Android theme for this Activity -->
// <meta-data
// android:name="io.flutter.embedding.android.NormalTheme"
// android:resource="@style/NormalTheme" />
//
// <!-- Intent Filter -->
// <intent-filter>
// <action android:name="android.intent.action.MAIN" />
// <category android:name="android.intent.category.LAUNCHER" />
// </intent-filter>
// </activity>
//
// <!-- Flutter Generated Plugin Registrant -->
// <meta-data
// android:name="flutterEmbedding"
// android:value="2" />
//
// <!-- Google Maps API Key -->
// <meta-data
// android:name="com.google.android.geo.API_KEY"
// android:value="YOUR_GOOGLE_MAPS_API_KEY" />
// </application>
//
// <!-- Queries for Activities that Process Text -->
// <queries>
// <intent>
// <action android:name="android.intent.action.PROCESS_TEXT" />
// <data android:mimeType="text/plain" />
// </intent>
// </queries>
// </manifest>
