import 'package:capitis_mad2_assignment_8/components/client_drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key, required this.uid});

  final String uid;

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final searchCtrl = TextEditingController();
  final fn = TextEditingController();
  final ln = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Home')),
      drawer: SafeArea(
        child: ClientDrawerComponent(id: widget.uid, currentScreen: "Home"),
      ),
      body: Center(child: QrImageView(data: widget.uid)),
    );
  }
}
