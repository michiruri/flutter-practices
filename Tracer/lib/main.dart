import 'package:capitis_mad2_assignment_8/firebase_options.dart';
import 'package:capitis_mad2_assignment_8/screens/client/client_home_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/establishment/establishment_home_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(TraceApp());
}

class TraceApp extends StatelessWidget {
  const TraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        listTileTheme: ListTileThemeData(selectedColor: Colors.blue),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            String uid = snapshot.data?.uid ?? '';
            return FutureBuilder(
              future: FirebaseFirestore.instance.collection('users').get(),
              builder: (context, docSnapshot) {
                if (docSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                for (var doc in docSnapshot.data!.docs) {
                  if (doc.id == uid) {
                    return ClientHomeScreen(uid: uid);
                  } else if (doc.id != uid) {
                    return EstablishmentHomeScreen(uid: uid);
                  } else {
                    return HomeScreen();
                  }
                }
                return HomeScreen();
              },
            );
          }
          return HomeScreen();
        },
      ),
    );
  }
}
