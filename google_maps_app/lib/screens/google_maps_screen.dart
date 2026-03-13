import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  LatLng initialPosition = LatLng(15.987481282041589, 120.57283750877448);
  late GoogleMapController mapCtrl;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  void addMarker(LatLng position) {
    if (markers.length < 3) {
      Marker marker = Marker(
        markerId: MarkerId('${markers.length + 1}'),
        position: position,
      );
      markers.add(marker);
      points.add(position);
      addPolyline();
      updateCameraPosition(position);
      showSnackBar('Added marker at $position');
    } else {
      markers.clear();
      points.clear();
      polylines.clear();
      showSnackBar('Cleared markers!');
    }
    setState(() {});
  }

  void addPolyline() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('${polylines.length + 1}'),
      points: points,
      color: Colors.blue,
    );
    polylines.add(polyline);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void updateCameraPosition(LatLng position) {
    mapCtrl.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        onMapCreated: (controller) => mapCtrl = controller,
        onTap: (LatLng position) => addMarker(position),
        markers: markers,
        polylines: polylines,
      ),
    );
  }
}
