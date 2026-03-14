import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetailsComponent extends StatelessWidget {
  const LocationDetailsComponent({super.key, required this.position});

  final Position? position;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                'Location Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text('Latitude'),
              trailing: Text('${position?.latitude}'),
            ),
            Divider(),
            ListTile(
              title: Text('Longitude'),
              trailing: Text('${position?.longitude}'),
            ),
            Divider(),
            ListTile(
              title: Text('Accuracy'),
              trailing: Text('${position?.accuracy}'),
            ),
            Divider(),
            ListTile(
              title: Text('Altitude'),
              trailing: Text('${position?.altitude}'),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
