import 'package:flutter/material.dart';
import 'package:image_picker_app/screens/pick_image_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PickImageScreen(),
    );
  }
}
