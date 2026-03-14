import 'package:capitis_mad2_assignment_6/screens/google_maps_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GoogleMapsApp());
}

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapsScreen(),
    );
  }
}
