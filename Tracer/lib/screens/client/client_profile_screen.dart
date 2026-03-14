import 'package:capitis_mad2_assignment_8/components/client_drawer_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final fnCtrl = TextEditingController();
  final mnCtrl = TextEditingController();
  final lnCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final birthdateCtrl = TextEditingController();
  final formattedBirthdateCtrl = TextEditingController();
  DateTime? selectedDate;

  String collectionPath = 'users';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Profile')),
      drawer: ClientDrawerComponent(id: widget.uid, currentScreen: "Profile"),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection(collectionPath)
                .doc(widget.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(8),
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
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: mnCtrl,
                    decoration: textFormDecoration('Middle Name'),
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
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: textFormDecoration('Address'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: birthdateCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month),
                      labelText: 'Birthdate',
                    ),
                    readOnly: true,
                    autofocus: false,
                    onTap: () => selectDate(),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => showUpdateAlert(),
                    child: Text('Update Details'),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  InputDecoration textFormDecoration(String labelText) {
    return InputDecoration(border: OutlineInputBorder(), labelText: labelText);
  }

  Future<void> fetchUserData() async {
    var user =
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(widget.uid)
            .get();
    emailCtrl.text = user['email'];
    fnCtrl.text = user['fn'];
    mnCtrl.text = user.data()!.containsKey('mn') ? user['mn'] : '';
    lnCtrl.text = user['ln'];
    addressCtrl.text =
        user.data()!.containsKey('address') ? user['address'].toString() : '';
    birthdateCtrl.text =
        user.data()!.containsKey('birthdate') ? user['birthdate'] : '';
  }

  Future<void> selectDate() async {
    await showDatePicker(
      context: context,
      firstDate: DateTime(1960),
      lastDate: DateTime(DateTime.now().year),
    ).then(
      (date) => setState(() {
        if (date != null) {
          selectedDate = date;
          birthdateCtrl.text = DateFormat('MMMM dd, yyyy').format(date);
        }
      }),
    );
  }

  void showUpdateAlert() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      onConfirmBtnTap: () {
        updateUserData();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> updateUserData() async {
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(widget.uid)
        .update({
          'email': emailCtrl.text,
          'fn': fnCtrl.text,
          'mn': mnCtrl.text,
          'ln': lnCtrl.text,
          'address': addressCtrl.text,
          'birthdate': birthdateCtrl.text,
        });

    Navigator.of(context).pop();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Profile updated successfully!',
    );
  }
}
