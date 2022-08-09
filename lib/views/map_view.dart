import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kou_navigation_project/constant.dart';
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
  static double _startingCameraLat = 40.821772;
  static double _startingCameraLng = 29.9222003;
  static double _startingCameraZoom = 16;
  static LatLng startPoint = LatLng(40.821772, 29.9222003);
  static LatLng finishPoint = LatLng(40.824689, 29.921045);
  String progressTitle = "Konum Bekleniyor";

  static final CameraPosition _statringLocation = CameraPosition(
    target: LatLng(_startingCameraLat, _startingCameraLng),
    zoom: _startingCameraZoom,
  );

  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;
  static LocationData? currentLocations;

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocations = location;
    });

    try {
      location.onLocationChanged.listen((newLoc) {
        currentLocations = newLoc;
        if (mounted) {
          setState(() {});
        }
      });
    } on Exception catch (_) {
      print('never reached');
    }

    print(currentLocations);
  }

  MapViewState(this.locationModel);

  @override
  void initState() {
    super.initState();
    _startingCameraLat = locationModel.lat!;
    _startingCameraLng = locationModel.lng!;
    getCurrentLocation();
    _goSelectedLocation(lat: locationModel.lat!, lng: locationModel.lng!);
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(startPoint.latitude, startPoint.longitude),
      PointLatLng(finishPoint.latitude, finishPoint.longitude),
      travelMode: TravelMode.walking,
    );

    //print(result);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: AppBar(
          title: Text(
            "${locationModel.name}",
            style: TextStyle(
              fontSize: 15,
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: currentLocations == null
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator()),
                  Text(
                    progressTitle,
                    style: TextStyle(fontSize: 35),
                  ),
                ],
              ))
            : GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                initialCameraPosition: _statringLocation,
                onMapCreated: (GoogleMapController controller) {
                  startPoint = LatLng(currentLocations!.latitude!,
                      currentLocations!.longitude!);
                  finishPoint = LatLng(locationModel.lat!, locationModel.lng!);
                  getPolyPoints();
                  _controller.complete(controller);
                },
                markers: _createMarker(),
                polylines: {
                  Polyline(
                      polylineId: PolylineId("Yol"),
                      points: polylineCoordinates,
                      color: Colors.red,
                      width: 5),
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            MapUtils.openMap(locationModel.lat!, locationModel.lng!);
          },
          label: Text(
            'Harita Uygulamasında Aç',
            style: TextStyle(color: Colors.white, fontSize: 15),
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
        markerId: MarkerId("${locationModel.name}"),
        position: LatLng(
            locationModel.lat ?? 40.822232, locationModel.lng ?? 29.921614),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      )
    ].toSet();
  }

  userCurrentLocation() async {
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
    locationData = await location.getLocation();

    return location;
  }

  Future<void> _goSelectedLocation(
      {required double lat, required double lng}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: _startingCameraZoom),
      ),
    );
  }
}
