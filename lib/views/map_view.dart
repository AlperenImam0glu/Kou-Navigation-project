import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:kou_navigation_project/constant.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/core/routing_googlemap_app.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class MapView extends StatefulWidget {
  LocationModels locationModel;
  MapView({Key? key, required this.locationModel}) : super(key: key);
  @override
  State<MapView> createState() => MapViewState(locationModel);
}

class MapViewState extends State<MapView> {
  LocationModels locationModel;
  Location location = new Location();
  late LocationData locationData;
  static double _startingCameraLat = 40.821772;
  static double _startingCameraLng = 29.9222003;
  static double _cameraZoom = 16;
  String progressTitle = "Konum Alınıyor";
  final String floatingActionButtoText = "Harita Uygulamasında Aç";
  static LocationData? currentLocations;
  final double appBarTitleSize = 15;
  final double circularProgressIndicatorTextSize = 35;
  final double circularProgressIndicatorHeigt = 100;
  final double floatingActionButtonTextSize = 15;
  static bool locationPermission = true;
  static bool isLocationEnable = true;

  @override
  void initState() {
    super.initState();
    _startingCameraLat = locationModel.lat!;
    _startingCameraLng = locationModel.lng!;
    getCurrentLocation();

    mapDrawTimer();
  }

  MapViewState(this.locationModel);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: Text(
            "${locationModel.name}",
            style: TextStyle(fontSize: appBarTitleSize),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          centerTitle: true),
      body: Text("${_startingCameraLat} ${_startingCameraLng}"),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButtonGoMap(),
    );
  }

  void _canRoadDraw() {
    if (currentLocations == null && locationPermission == false) {
      if (mounted) {
        setState(() {
          isLocationEnable = false;
        });
      }
    }
  }

  void mapDrawTimer() {
    var counter = 4;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (counter % 2 == 0) {
            progressTitle = "Lütfen bekleyiniz";
          } else {
            progressTitle = "Konum Alınıyor";
          }
        });
      }

      if (counter == 0) {
        if (currentLocations == null) {
          locationPermission = false;
          _canRoadDraw();
        }
        timer.cancel();
      }
      counter--;
    });
  }

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocations = location;
      if (mounted) {
        setState(() {});
      }
    });
  }

  FloatingActionButton _floatingActionButtonGoMap() {
    return FloatingActionButton.extended(
      onPressed: () {
        MapUtils.openMap(locationModel.lat!, locationModel.lng!);
      },
      label: Text(
        floatingActionButtoText,
        style: TextStyle(
            color: Colors.white, fontSize: floatingActionButtonTextSize),
      ),
      icon: Icon(
        Icons.assistant_direction_rounded,
        color: Colors.white,
      ),
    );
  }

  Center _circularProgress() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: circularProgressIndicatorHeigt,
          width: circularProgressIndicatorHeigt,
          child: CircularProgressIndicator(),
        ),
        Text(
          progressTitle,
          style: TextStyle(fontSize: circularProgressIndicatorTextSize),
        ),
      ],
    ));
  }
}
