import 'package:capitis_mad2_assignment_8/components/client_drawer_component.dart';
import 'package:capitis_mad2_assignment_8/screens/client/client_establishment_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientEstablishmentsListingScreen extends StatefulWidget {
  const ClientEstablishmentsListingScreen({super.key, required this.uid});

  final String uid;

  @override
  State<ClientEstablishmentsListingScreen> createState() =>
      _ClientEstablishmentsListingScreenState();
}

class _ClientEstablishmentsListingScreenState
    extends State<ClientEstablishmentsListingScreen> {
  String collectionPath = 'establishments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Establishments'), centerTitle: true),
      drawer: ClientDrawerComponent(
        id: widget.uid,
        currentScreen: 'Establishments',
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(collectionPath).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var establishments = snapshot.data?.docs;
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: establishments?.length,
              itemBuilder: (context, index) {
                var establishment = establishments?[index];
                return Card(
                  child: ListTile(
                    onTap: () => addVisited(establishment!.id),
                    title: Text(establishment?['business']),
                    subtitle: Text(establishment?['address']),
                  ),
                );
              },
            );
          }
          return Center(child: Text('No Existing Establishments'));
        },
      ),
    );
  }

  Future<void> addVisited(String establishmentID) async {
    String collectionPath = '/users/${widget.uid}/visited';
    await FirebaseFirestore.instance.collection(collectionPath).add({
      'establishment_id': establishmentID,
      'date_visited': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      'datetime_visited': DateFormat(
        'MMMM dd, yyyy - hh:mm:ss',
      ).format(DateTime.now()),
    });
    addVisitor(establishmentID);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => ClientEstablishmentView(
              uid: widget.uid,
              establishmentID: establishmentID,
            ),
      ),
    );
  }

  Future<void> addVisitor(String establishmentID) async {
    String collectionPath = '/establishments/$establishmentID/visitors';
    await FirebaseFirestore.instance.collection(collectionPath).add({
      'user_id': widget.uid,
      'date_visited': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      'datetime_visited': DateFormat(
        'MMMM dd, yyyy - hh:mm:ss',
      ).format(DateTime.now()),
    });
  }
}
