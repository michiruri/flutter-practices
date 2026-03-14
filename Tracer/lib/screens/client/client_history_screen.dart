import 'package:capitis_mad2_assignment_8/components/client_drawer_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientHistoryScreen extends StatefulWidget {
  const ClientHistoryScreen({super.key, required this.uid});

  final String uid;

  @override
  State<ClientHistoryScreen> createState() => _ClientHistoryScreenState();
}

class _ClientHistoryScreenState extends State<ClientHistoryScreen> {
  DateTime? selectedDate;
  final dateCtrl = TextEditingController();

  @override
  void initState() {
    dateCtrl.text = DateFormat("MMMM dd, yyyy").format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String collectionPath = '/users/${widget.uid}/visited';
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      drawer: ClientDrawerComponent(id: widget.uid, currentScreen: 'History'),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection(collectionPath)
                .where('date_visited', isEqualTo: dateCtrl.text)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var visited = snapshot.data?.docs;
            return SizedBox(
              height: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: dateCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_month),
                        labelText: 'Select Date',
                      ),
                      readOnly: true,
                      autofocus: false,
                      onTap: () => selectDate(),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: visited?.length,
                        itemBuilder: (context, index) {
                          var visit = visited?[index];
                          return StreamBuilder(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('establishments')
                                    .doc(visit?['establishment_id'])
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var establishment = snapshot.data;
                                return Card(
                                  child: ListTile(
                                    title: Text(establishment?['business']),
                                    subtitle: Text(visit?['datetime_visited']),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('No Visited Establishments Yet...'));
        },
      ),
    );
  }

  Future<void> selectDate() async {
    await showDatePicker(
      context: context,
      firstDate: DateTime(1960),
      currentDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(2050),
    ).then(
      (date) => setState(() {
        if (date != null) {
          selectedDate = date;
          dateCtrl.text = DateFormat('MMMM dd, yyyy').format(date);
        }
      }),
    );
  }
}
