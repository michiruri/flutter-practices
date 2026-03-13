import 'package:capitis_mad2_assignment_4/screens/playlist_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: Typography(platform: TargetPlatform.android).white,
        scaffoldBackgroundColor: Color(0xFF020403),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(color: Colors.white),
          subtitleTextStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: PlaylistScreen(),
    );
  }
}
