import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/core/routing_googleMap_app.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class MapView extends StatefulWidget {
  LocationModels locationModel;
  MapView({Key? key, required this.locationModel}) : super(key: key);
  @override
  State<MapView> createState() => MapViewState(locationModel);
}

class MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  LocationModels locationModel;
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

  MapViewState(this.locationModel);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: AppBar(
          title: Text(
            "${locationModel.name}",
            maxLines: 1,
          ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            MapUtils.openMap(locationModel.lat!, locationModel.lng!);
          },
          label: Text(
            'Konuma Git',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          icon: Icon(
            Icons.assistant_direction_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("Secilen Konum"),
        position: LatLng(
            locationModel.lat ?? 40.822232, locationModel.lng ?? 29.921614),
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
