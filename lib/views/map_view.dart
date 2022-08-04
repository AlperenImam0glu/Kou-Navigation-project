import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kou_navigation_project/constant.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/core/routing_googleMap_app.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  LocationModels locationModel;
  MapView({Key? key, required this.locationModel}) : super(key: key);
  @override
  State<MapView> createState() => MapViewState(locationModel);
}

class MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  LocationModels locationModel;
  static double _startingLat = 40.821772;
  static double _startingLng = 29.9222003;
  static double _startingZoom = 15;
  static LatLng start = LatLng(40.821772, 29.9222003);
  static LatLng finish = LatLng(40.824689, 29.921045);

  var lo;

  static final CameraPosition _statringLocation = CameraPosition(
    target: LatLng(_startingLat, _startingLng),
    zoom: _startingZoom,
  );

  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;
  static LocationData? currentLocations;

  MapViewState(this.locationModel);

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocations = location;
    });
    location.onLocationChanged.listen((newLoc) {
      currentLocations = newLoc;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    _startingLat = locationModel.lat!;
    _startingLng = locationModel.lng!;
    //currentLocation();
    getCurrentLocation();

    _goCurrentLocation(lat: locationModel.lat!, lng: locationModel.lng!);
    //  getPolyPoints();
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(_startingLat, _startingLng),
      PointLatLng(finish.latitude, finish.longitude),
      travelMode: TravelMode.walking,
    );

    print(result);
    if (!result.points.isEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
    setState(() {});
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
        body: currentLocations == null
            ? Center(
                child: Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator()))
            : GoogleMap(
                mapType: MapType.hybrid,
                myLocationEnabled: true,
                initialCameraPosition: _statringLocation,
                onMapCreated: (GoogleMapController controller) {
                  finish = LatLng(currentLocations!.latitude!,
                      currentLocations!.longitude!);
                  start = LatLng(locationModel.lat!, locationModel.lng!);
                  getPolyPoints();
                  _controller.complete(controller);
                },
                markers: _createMarker(),
                polylines: {
                  Polyline(
                      polylineId: PolylineId("value"),
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
        markerId: MarkerId("${locationModel.name}"),
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
    locationData = await location.getLocation();
    /*
    _goCurrentLocation(
        lat: locationData!.latitude!, lng: locationData!.longitude!); */
    return location;
  }

  Future<void> _goCurrentLocation(
      {required double lat, required double lng}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 16),
      ),
    );
  }
}
