import 'package:capitis_mad2_assignment_8/screens/client/client_home_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/establishment/establishment_home_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool isPasswordField = false;
  bool hidePassword = true;
  bool isFormValidated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        leading: IconButton(
          onPressed:
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              ),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailCtrl,
                decoration: textFormDecoration('Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required';
                  }
                  if (!EmailValidator.validate(value)) {
                    return '*Invalid email';
                  }
                  return null;
                },
                onChanged: (value) => validateForm(),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: passwordCtrl,
                obscureText: hidePassword,
                decoration: textFormDecoration(
                  'Password',
                  isPasswordField: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required';
                  }
                  if (value.length < 6) {
                    return '*Password must be at least 6 characters long.';
                  }
                  return null;
                },
                onChanged: (value) => validateForm(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => loginClient(),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration textFormDecoration(
    String labelText, {
    bool isPasswordField = false,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: labelText,
      suffixIcon:
          isPasswordField
              ? IconButton(
                onPressed: () => toggleShowPassword(),
                icon: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                ),
              )
              : null,
    );
  }

  void toggleShowPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void validateForm() {
    isFormValidated = true;
    if (!formKey.currentState!.validate()) {
      isFormValidated = false;
      return;
    }
  }

  Future<void> loginClient() async {
    validateForm();
    if (!isFormValidated) {
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Logging in',
      text: 'Please wait...',
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailCtrl.text,
            password: passwordCtrl.text,
          );
      String uid = userCredential.user!.uid;
      final document =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Widget? destination;
      if (document.data() != null) {
        destination = ClientHomeScreen(uid: uid);
      } else {
        destination = EstablishmentHomeScreen(uid: uid);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => destination!),
        (route) => false,
      );
    } on FirebaseAuthException catch (ex) {
      Navigator.of(context).pop();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Login Failed',
        text: ex.message,
      );
    }
  }
}
