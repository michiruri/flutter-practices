import 'package:capitis_mad2_assignment_7/screens/google_maps_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String collectionPath = 'favorites';
  final formKey = GlobalKey<FormState>();
  final positionCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  void showDialogue(var favorite) async {
    getFavoriteDetails(favorite);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Favorite Place'),
          iconColor: Colors.red,
          icon: Icon(Icons.favorite, size: 32),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator: (value) => validator(value),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: descCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  validator: (value) => validator(value),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: positionCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Position: ',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => showDeleteAlert(favorite),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => setToFirestore(),
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void viewFavorite(var favorite) async {
    getFavoriteDetails(favorite);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('View Favorite Place'),
          iconColor: Colors.red,
          icon: Icon(Icons.favorite, size: 32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: positionCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Position: ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void getFavoriteDetails(var favorite) {
    positionCtrl.text =
        '${favorite['position']['latitude']}, ${favorite['position']['longitude']}';
    nameCtrl.text = favorite['name'];
    descCtrl.text = favorite['desc'];
  }

  void showDeleteAlert(var favorite) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      onConfirmBtnTap: () => deleteFromFirestore(favorite),
    );
  }

  void showSuccessAlert(String text) {
    QuickAlert.show(context: context, type: QuickAlertType.success, text: text);
  }

  Future<void> deleteFromFirestore(var favorite) async {
    getFavoriteDetails(favorite);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(positionCtrl.text)
        .delete();
    Navigator.of(context).pop();
    showSuccessAlert('Deleted successfully!');
    setState(() {});
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return '* Required';
    }
    return null;
  }

  Future<void> setToFirestore() async {
    Navigator.of(context).pop();
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    double latitude = double.parse(positionCtrl.text.split(',').first);
    double longitude = double.parse(positionCtrl.text.split(',').last);
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(positionCtrl.text)
        .set(({
          'name': nameCtrl.text,
          'desc': descCtrl.text,
          'position': {'latitude': latitude, 'longitude': longitude},
        }));
    Navigator.of(context).pop();
    showSuccessAlert('Updated successfully!');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed:
              () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => GoogleMapsScreen()),
                (route) => true,
              ),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Favorite Places'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.favorite, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection(collectionPath).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var favorites = snapshot.data?.docs;
            return ListView.builder(
              itemCount: favorites?.length,
              itemBuilder: (context, index) {
                var favorite = favorites?[index];
                return Card(
                  child: ListTile(
                    onTap: () => viewFavorite(favorite),
                    title: Text(favorite?['name'] ?? ''),
                    subtitle: Text(favorite?['desc'] ?? ''),
                    trailing: IconButton(
                      onPressed: () => showDialogue(favorite),
                      icon: Icon(Icons.edit),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
