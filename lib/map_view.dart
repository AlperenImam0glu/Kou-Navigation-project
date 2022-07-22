import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static double _startingLat = 40.821858;
  static double _startingLng = 29.9222003;
  static double _startingZoom = 15;

  static final CameraPosition _statringLocation = CameraPosition(
    target: LatLng(_startingLat, _startingLng),
    zoom: _startingZoom,
  );

  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: AppBar(
          title: Text("Harita"),
          centerTitle: true,
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          initialCameraPosition: _statringLocation,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _createMarker(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: currentLocation,
          label: Text('Konumum'),
          icon: Icon(Icons.my_location_outlined),
        ),
      ),
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("asdasd"),
        position: LatLng(40.821836, 29.923525),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      )
    ].toSet();
  }

  currentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    _goCurrentLocation(
        lat: _locationData.latitude!, lng: _locationData.longitude!);
  }

  Future<void> _goCurrentLocation(
      {required double lat, required double lng}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 17.0),
      ),
    );
  }
}
