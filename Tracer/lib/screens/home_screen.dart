
import 'package:capitis_mad2_assignment_8/screens/client/client_register_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/establishment/establishment_register_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => navigate(LoginScreen()),
              child: Text('Login'),
            ),
            Divider(),
            ElevatedButton(
              onPressed: () => navigate(ClientRegisterScreen()),
              child: Text('Register as Client'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => navigate(EstablishmentRegisterScreen()),
              child: Text('Register as Establishment'),
            ),
          ],
        ),
      ),
    );
  }

  void navigate(Widget destination) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => destination));
  }
}
