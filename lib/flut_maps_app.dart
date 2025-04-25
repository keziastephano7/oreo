import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? userLocation;
  List<Marker> hotelMarkers = [];

  @override
  void initState() {
    super.initState();
    getUserLocationAndHotels();
  }

  Future<void> getUserLocationAndHotels() async {
    final position = await _determinePosition();
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });

    await fetchNearbyHotels(position.latitude, position.longitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> fetchNearbyHotels(double lat, double lon) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=hotel&limit=10&bounded=1&viewbox=${lon - 0.02},${lat + 0.02},${lon + 0.02},${lat - 0.02}');

    final response = await http.get(url, headers: {
      'User-Agent': 'flutter-hotel-app' // required by OSM
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        hotelMarkers = data.map((place) {
          final double placeLat = double.parse(place['lat']);
          final double placeLon = double.parse(place['lon']);
          return Marker(
            point: LatLng(placeLat, placeLon),
            width: 40,
            height: 40,
            child: const Icon(Icons.hotel, color: Colors.red),
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Hotels")),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          center: userLocation,
          zoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate:
            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: [
            Marker(
              point: userLocation!,
              width: 50,
              height: 50,
              child: const Icon(Icons.person_pin_circle,
                  color: Colors.blue, size: 40),
            ),
            ...hotelMarkers,
          ]),
        ],
      ),
    );
  }
}

// in android/app/src/main/AndroidManifest.xml
// within manifest tag
// <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
// <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
// within application tag
// <uses-library android:name="org.apache.http.legacy" android:required="false"/>

// in pubspec.yaml
//   flutter_map: ^6.0.1
//   latlong2: ^0.9.0
//   geolocator: ^10.1.0
//   http: ^1.3.0
