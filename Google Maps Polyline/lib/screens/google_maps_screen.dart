import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  LatLng initialPosition = LatLng(15.988375664303891, 120.57304885410129);
  late GoogleMapController mapCtrl;
  Set<Marker> markers = {};
  List<LatLng> points = [];
  Set<Polyline> polylines = {};

  Future<void> addMarker(LatLng position) async {
    if (markers.length < 2) {
      Marker marker = Marker(
        markerId: MarkerId('${markers.length + 1}'),
        position: position,
        icon:
            markers.isEmpty
                ? BitmapDescriptor.defaultMarker
                : await BitmapDescriptor.asset(
                  ImageConfiguration(size: Size.square(64)),
                  'assets/images/destination_marker.png',
                ),
      );
      markers.add(marker);

      points.add(position);
      updateCameraPosition(position);
      addPolyline();
    } else {
      markers.clear();
      points.clear();
      polylines.clear();

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('All locations has been reset.')));
    }
    setState(() {});
  }

  void addPolyline() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('${polylines.length + 1}'),
      points: points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      color: Colors.blue,
    );
    polylines.add(polyline);
  }

  void updateCameraPosition(LatLng position) {
    mapCtrl.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: markers,
        polylines: polylines,
        initialCameraPosition: CameraPosition(target: initialPosition),
        onMapCreated: (controller) => mapCtrl = controller,
        onTap: (LatLng position) => addMarker(position),
      ),
    );
  }
}
