import 'package:capitis_mad2_assignment_8/components/establishment_drawer_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:quickalert/quickalert.dart';

class EstablishmentHomeScreen extends StatefulWidget {
  const EstablishmentHomeScreen({super.key, required this.uid});

  final String uid;

  @override
  State<EstablishmentHomeScreen> createState() =>
      _EstablishmentHomeScreenState();
}

class _EstablishmentHomeScreenState extends State<EstablishmentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Establishment Home')),
      drawer: EstablishmentDrawerComponent(
        id: widget.uid,
        currentScreen: 'Home',
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => scanQR(),
          child: Text('Scan Client QR Code'),
        ),
      ),
    );
  }

  void scanQR() async {
    var qr = await FlutterBarcodeScanner.scanBarcode(
      '',
      'Cancel',
      true,
      ScanMode.DEFAULT,
    );

    QuickAlert.show(context: context, type: QuickAlertType.loading);
    Navigator.of(context).pop();
    var users = await FirebaseFirestore.instance.collection('users').get();
    for (var user in users.docs) {
      String userFullname = user['fn'];
      String middleName = user.data().containsKey('mn') ? user['mn'] : '';
      if (middleName != '') {
        userFullname += middleName;
      }
      userFullname += user['ln'];
      if (user.id == qr) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Valid Client QR Code',
          text: 'Client Name: $userFullname\n',
        );
        return;
      }
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Invalid Client QR Code',
      text: 'Client does not exist.',
    );
  }
}
