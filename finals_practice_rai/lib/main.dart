import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finals_practice_rai/firebase_options.dart';
import 'package:finals_practice_rai/screens/home_screen.dart';
import 'package:finals_practice_rai/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            String uid = snapshot.data!.uid;
            print(uid);
            return HomeScreen(uid: uid);
          }
          return LoginScreen();
        },
      ),
    );
  }
}
