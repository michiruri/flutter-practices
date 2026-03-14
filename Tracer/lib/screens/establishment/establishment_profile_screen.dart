import 'package:capitis_mad2_assignment_8/components/establishment_drawer_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class EstablishmentProfileScreen extends StatefulWidget {
  const EstablishmentProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  State<EstablishmentProfileScreen> createState() =>
      _EstablishmentProfileScreenState();
}

class _EstablishmentProfileScreenState
    extends State<EstablishmentProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final contactPersonCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  DateTime? selectedDate;

  String collectionPath = 'establishments';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Establishment Profile')),
      drawer: EstablishmentDrawerComponent(
        id: widget.uid,
        currentScreen: "Profile",
      ),
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
                    controller: nameCtrl,
                    decoration: textFormDecoration('Establishment Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: contactPersonCtrl,
                    decoration: textFormDecoration('Contact Person'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: textFormDecoration('Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
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
    var establishment =
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(widget.uid)
            .get();
    nameCtrl.text = establishment['business'];
    contactPersonCtrl.text =
        establishment.data()!.containsKey('contact_person')
            ? establishment['contact_person']
            : '';
    addressCtrl.text =
        establishment.data()!.containsKey('address')
            ? establishment['address'].toString()
            : '';
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
          'business': nameCtrl.text,
          'contact_person': contactPersonCtrl.text,
          'address': addressCtrl.text,
        });

    Navigator.of(context).pop();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Profile updated successfully!',
    );
  }
}
