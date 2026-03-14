import 'package:capitis_mad2_assignment_8/components/establishment_drawer_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EstablishmentVisitorsScreen extends StatefulWidget {
  const EstablishmentVisitorsScreen({super.key, required this.uid});

  final String uid;

  @override
  State<EstablishmentVisitorsScreen> createState() =>
      _EstablishmentVisitorsScreenState();
}

class _EstablishmentVisitorsScreenState
    extends State<EstablishmentVisitorsScreen> {
  DateTime? selectedDate;
  final dateCtrl = TextEditingController();

  @override
  void initState() {
    dateCtrl.text = DateFormat("MMMM dd, yyyy").format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String collectionPath = '/establishments/${widget.uid}/visitors';
    return Scaffold(
      appBar: AppBar(title: Text('Visitor History'), centerTitle: true),
      drawer: EstablishmentDrawerComponent(
        id: widget.uid,
        currentScreen: 'History',
      ),
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
            var visitors = snapshot.data?.docs;
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
                        itemCount: visitors?.length,
                        itemBuilder: (context, index) {
                          var visitor = visitors?[index];
                          return StreamBuilder(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(visitor?['user_id'])
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var user = snapshot.data;
                                String userFullname = user?['fn'];
                                String middleName =
                                    user!.data()!.containsKey('mn')
                                        ? user['mn']
                                        : '';
                                if (middleName != '') {
                                  userFullname += middleName;
                                }
                                userFullname += user['ln'];
                                return Card(
                                  child: ListTile(
                                    title: Text(userFullname),
                                    subtitle: Text(
                                      visitor?['datetime_visited'],
                                    ),
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
