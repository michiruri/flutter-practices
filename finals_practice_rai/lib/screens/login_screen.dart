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
  bool isObscured = true;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
    } on FirebaseAuthException catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Registration Failed',
        text: e.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Email is required.";
                  }
                  if (!EmailValidator.validate(emailCtrl.text)) {
                    return "*Email is invalid.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordCtrl,
                obscureText: isObscured,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      isObscured = !isObscured;
                      setState(() {});
                    },
                    icon: Icon(
                      isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "*Password is required.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: () => login(), child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
