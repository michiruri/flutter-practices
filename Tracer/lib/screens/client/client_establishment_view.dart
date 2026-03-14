import 'package:capitis_mad2_assignment_8/screens/client/client_establishments_listing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientEstablishmentView extends StatefulWidget {
  const ClientEstablishmentView({
    super.key,
    required this.uid,
    required this.establishmentID,
  });

  final String uid;
  final String establishmentID;

  @override
  State<ClientEstablishmentView> createState() =>
      _ClientEstablishmentViewState();
}

class _ClientEstablishmentViewState extends State<ClientEstablishmentView> {
  String collectionPath = 'establishments';

  final nameCtrl = TextEditingController();
  final contactPersonCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Establishment Details'),
        centerTitle: true,
        leading: IconButton(
          onPressed:
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ClientEstablishmentsListingScreen(uid: widget.uid),
                ),
              ),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection(collectionPath)
                .doc(widget.establishmentID)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            fetchData(snapshot.data);
            return ListView(
              padding: EdgeInsets.all(8),
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: textFormDecoration('Establishment Name'),
                  readOnly: true,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: contactPersonCtrl,
                  decoration: textFormDecoration('Contact Person'),
                  readOnly: true,
                ),
                SizedBox(height: 8),
                TextField(
                  controller: addressCtrl,
                  decoration: textFormDecoration('Address'),
                  readOnly: true,
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> fetchData(establishment) async {
    nameCtrl.text = establishment['business'];
    contactPersonCtrl.text =
        establishment.data()!.containsKey('contact_person')
            ? establishment['contact_person']
            : '';
    addressCtrl.text = establishment['address'];
  }

  InputDecoration textFormDecoration(String labelText) {
    return InputDecoration(border: OutlineInputBorder(), labelText: labelText);
  }
}
