import 'package:capitis_mad2_assignment_5/screens/location_weather_details_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HikingApp());
}

class HikingApp extends StatelessWidget {
  const HikingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff141414),
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
        ),
        textTheme: Typography(platform: TargetPlatform.android).white,
        iconTheme: IconThemeData(color: Colors.white),
        cardTheme: CardTheme(color: Colors.white.withValues(alpha: 0.1)),
        cardColor: Colors.grey,
        listTileTheme: ListTileThemeData(
          iconColor: Colors.white,
          textColor: Colors.white,
          subtitleTextStyle: TextStyle(fontSize: 12),
          leadingAndTrailingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
            color: Colors.grey,
          ),
          minTileHeight: 0,
        ),
        dividerTheme: DividerThemeData(
          thickness: 0.2,
          indent: 16,
          endIndent: 20,
        ),
        dialogTheme: DialogTheme(backgroundColor: Color(0xff141414)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (states) => Colors.white.withValues(alpha: 0.1),
            ),
            foregroundColor: WidgetStateColor.resolveWith(
              (states) => Colors.white,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          counterStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LocationWeatherDetailsScreen(),
    );
  }
}
