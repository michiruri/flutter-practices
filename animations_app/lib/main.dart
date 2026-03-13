import 'package:animations_app/screens/explicit_animations_screen.dart';
import 'package:animations_app/screens/implicit_animations_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImplicitAnimationsScreen(),
    );
  }
}
