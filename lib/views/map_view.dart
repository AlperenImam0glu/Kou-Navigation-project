import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/core/routing_googlemap_app.dart';
import 'package:kou_navigation_project/osm_example/home_example.dart';
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
  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  void initState() {
    super.initState();
    _startingCameraLat = locationModel.lat!;
    _startingCameraLng = locationModel.lng!;
    getCurrentLocation();

    mapDrawTimer();
  }

  MapViewState(this.locationModel);
  MapController mapController = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 40.821768, longitude: 29.926135),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Harita"),
      ),
      body: OSMFlutter(
        controller: mapController,
        trackMyPosition: true,
        initZoom: 17,
        minZoomLevel: 2,
        maxZoomLevel: 18,
        stepZoom: 1.0,
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            icon: Icon(
              Icons.circle,
              color: Colors.blue,
              size: 60,
            ),
          ),
          directionArrowMarker: MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 48,
            ),
          ),
        ),
        roadConfiguration: RoadConfiguration(
          startIcon: MarkerIcon(
            icon: Icon(
              Icons.person,
              size: 64,
              color: Colors.brown,
            ),
          ),
          roadColor: Colors.yellowAccent,
        ),
        markerOption: MarkerOption(
            defaultMarker: MarkerIcon(
          icon: Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 56,
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          roadActionBt(context);
        },
      ),
    );
  }

  void roadActionBt(BuildContext ctx) async {
    try {
      await mapController.removeLastRoad();

      GeoPoint point = await mapController.selectPosition(
        icon: MarkerIcon(
          icon: Icon(
            Icons.person_pin_circle,
            color: Colors.amber,
            size: 100,
          ),
        ),
      );
      GeoPoint point2 = await mapController.selectPosition();

      ValueNotifier<RoadType> notifierRoadType = ValueNotifier(RoadType.car);

      final bottomPersistant = scaffoldKey.currentState!.showBottomSheet(
        (ctx) {
          return RoadTypeChoiceWidget(
            setValueCallback: (roadType) {
              notifierRoadType.value = roadType;
            },
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      );
      await bottomPersistant.closed.then((roadType) async {
        RoadInfo roadInformation = await mapController.drawRoad(
          point, point2,
          roadType: notifierRoadType.value,
          //interestPoints: [pointM1, pointM2],
          roadOption: RoadOption(
            roadWidth: 10,
            roadColor: Colors.blue,
            showMarkerOfPOI: true,
            zoomInto: true,
          ),
        );
        print(
            "duration:${Duration(seconds: roadInformation.duration!.toInt()).inMinutes}");
        print("distance:${roadInformation.distance}Km");
        print(roadInformation.route.length);
      });
    } on RoadException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${e.errorMessage()}",
          ),
        ),
      );
    }
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
