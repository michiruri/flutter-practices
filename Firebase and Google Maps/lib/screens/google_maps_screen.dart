import 'package:capitis_mad2_assignment_7/screens/favorites_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/quickalert.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  LatLng initialCamPosition = LatLng(15.98830721468596, 120.57355068152292);
  Set<Marker> markers = {};
  late GoogleMapController mapCtrl;

  final formKey = GlobalKey<FormState>();
  final positionCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String action = 'Add';

  String collectionPath = 'favorites';

  void showDialogue(LatLng position, String act) async {
    action = act;
    nameCtrl.clear();
    descCtrl.clear();
    updateCameraPosition(position);
    positionCtrl.text = '${position.latitude}, ${position.longitude}';
    if (action == 'Edit') {
      var favorite =
          await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(positionCtrl.text)
              .get();
      nameCtrl.text = favorite['name'];
      descCtrl.text = favorite['desc'];
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$action Favorite Place'),
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
            if (action == 'Edit')
              TextButton(
                onPressed: () => showDeleteAlert(),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => setMarker(position),
              child: Text(action == 'Add' ? action : 'Update'),
            ),
          ],
        );
      },
    );
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return '* Required';
    }
    return null;
  }

  void showDeleteAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      onConfirmBtnTap: () => deleteFromFirestore(),
    );
  }

  void showSuccessAlert(String text) {
    QuickAlert.show(context: context, type: QuickAlertType.success, text: text);
  }

  Future<void> deleteFromFirestore() async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(positionCtrl.text)
        .delete();
    markers.removeWhere(
      (marker) => marker.markerId == MarkerId(positionCtrl.text),
    );
    Navigator.of(context).pop();
    showSuccessAlert('Deleted successfully!');
    setState(() {});
  }

  void updateCameraPosition(LatLng position) {
    mapCtrl.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 8)),
    );
  }

  void setMarker(LatLng position) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop();
    setToFirestore();
    fetchFromFirestore();
    setState(() {});
  }

  Future<void> setToFirestore() async {
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
    showSuccessAlert(
      action == 'Add' ? 'Added successfully!' : 'Updated successfully!',
    );
  }

  Future<void> fetchFromFirestore() async {
    markers.clear();
    var favorites =
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .where('')
            .get();
    for (var favorite in favorites.docs) {
      LatLng position = LatLng(
        favorite['position']['latitude'],
        favorite['position']['longitude'],
      );
      String name = favorite['name'];
      String desc = favorite['desc'];

      Marker marker = Marker(
        markerId: MarkerId('${position.latitude}, ${position.longitude}'),
        position: position,
        onTap: () => showDialogue(position, 'Edit'),
        infoWindow: InfoWindow(title: name, snippet: desc),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size.square(24)),
          'assets/icons/heart.png',
        ),
      );
      markers.add(marker);
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchFromFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialCamPosition,
          zoom: 8,
        ),
        markers: markers,
        onMapCreated: (controller) => mapCtrl = controller,
        onTap: (position) => showDialogue(position, 'Add'),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed:
            () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => FavoritesScreen())),
        foregroundColor: Colors.red,
        backgroundColor: Colors.white,
        child: Icon(Icons.favorite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}
