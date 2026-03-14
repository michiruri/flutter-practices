import 'package:capitis_mad2_assignment_8/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ClientRegisterScreen extends StatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  State<ClientRegisterScreen> createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final fnCtrl = TextEditingController();
  final lnCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  bool isPasswordField = false;
  bool hidePassword = true;
  bool isFormValidated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register as Client')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fnCtrl,
                decoration: textFormDecoration('First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required';
                  }
                  return null;
                },
                onChanged: (value) => validateForm(),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: lnCtrl,
                decoration: textFormDecoration('Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required';
                  }
                  return null;
                },
                onChanged: (value) => validateForm(),
              ),
              SizedBox(height: 8),
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
              TextFormField(
                controller: confirmPasswordCtrl,
                obscureText: hidePassword,
                decoration: textFormDecoration(
                  'Confirm Password',
                  isPasswordField: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required';
                  }
                  if (value.length < 6) {
                    return '*Password must be at least 6 characters long.';
                  }
                  if (value != passwordCtrl.text) {
                    return '*Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) => validateForm(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => showRegisterAlert(),
                child: Text('Register'),
              ),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
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

  void showRegisterAlert() {
    validateForm();
    if (!isFormValidated) {
      return;
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Confirm Registration?',
      confirmBtnText: 'YES',
      cancelBtnText: 'NO',
      onConfirmBtnTap: () => registerClient(),
    );
  }

  Future<void> registerClient() async {
    Navigator.of(context).pop();
    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Please wait',
        text: 'Registering your account',
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailCtrl.text,
            password: passwordCtrl.text,
          );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'fn': fnCtrl.text, 'ln': lnCtrl.text, 'email': emailCtrl.text});

      Navigator.of(context).pop();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Client Registration',
        text: 'Your account has been registered. You can now login.',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
      );
    } on FirebaseAuthException catch (ex) {
      Navigator.of(context).pop();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: ex.message,
      );
    }
  }
}
