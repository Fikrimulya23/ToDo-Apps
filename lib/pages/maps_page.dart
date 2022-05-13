// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

class MapsPage extends StatefulWidget {
  const MapsPage({
    Key? key,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  // ignore: prefer_final_fields
  Completer<GoogleMapController> _controller = Completer();

  // ignore: prefer_final_fields, prefer_collection_literals
  Set<Marker> _markers = Set<Marker>();

  int distance = 0;

  late LatLng tempPosition;

  late CameraPosition _kGooglePlex;

  void _setTempMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('marker'),
        infoWindow: InfoWindow(title: 'Master'),
        position: point,
      ));
    });
  }

  void _setMarker(LatLng point) {
    print("Koordinat saat ini: $point");
    setState(() {
      widget._controller.text =
          point.latitude.toString() + " " + point.longitude.toString();
    });
    Navigator.pop(context);
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    var point = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    tempPosition = LatLng(point.latitude, point.longitude);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: tempPosition, zoom: 80)));

    _setTempMarker(LatLng(point.latitude, point.longitude));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _setTempMarker(LatLng(-6.6512086, 106.6384095));
    (widget._controller.text.isNotEmpty) ? null : getCurrentLocation();
    final temp = widget._controller.text.split(' ');
    _kGooglePlex = CameraPosition(
      target: (widget._controller.text.isNotEmpty)
          ? LatLng(double.parse(temp[0]), double.parse(temp[1]))
          : LatLng(-6.6512086, 106.6384095),
      zoom: 80,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Flutter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
        child: Icon(Icons.my_location),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: _markers,
              onLongPress: (point) {
                _setMarker(point);
              },
              onCameraMove: (point) {
                setState(() {
                  tempPosition = point.target;
                  _setTempMarker(point.target);
                });
              },
              onTap: (point) {
                setState(() {
                  tempPosition = point;
                  _setTempMarker(point);
                });
              },
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
