import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kou_navigation_project/constant/constant.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/core/routing_googlemap_app.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';
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
  List<LatLng> polylineCoordinates = [];
  Location location = new Location();
  late LocationData locationData;
  static double _startingCameraLat = 40.821772;
  static double _startingCameraLng = 29.9222003;
  static double _cameraZoom = 16;
  static LatLng startPoint = LatLng(40.821772, 29.9222003);
  static LatLng finishPoint = LatLng(40.824689, 29.921045);
  String progressTitle = "Konum Alınıyor";
  final String floatingActionButtoText = "Harita Uygulamasında Aç";
  static LocationData? currentLocations;
  final double appBarTitleSize = 15;
  final double circularProgressIndicatorTextSize = 35;
  final double circularProgressIndicatorHeigt = 100;
  final double floatingActionButtonTextSize = 15;
  static bool locationPermission = true;
  static bool isLocationEnable = true;
  bool networkConnection = false;
  final _lightColor = LightColor();
  final String networkCheckText = "İnternet Bağlantınızı Kontrol Ediniz";

  @override
  void initState() {
    super.initState();
    _startingCameraLat = locationModel.lat!;
    _startingCameraLng = locationModel.lng!;
    checkNetwork();
    getCurrentLocation();
    _goSelectedLocation(lat: locationModel.lat!, lng: locationModel.lng!);
    mapDrawTimer();
  }

  void checkNetwork() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('İnternet Bağlantısı var');
      networkConnection = true;
    } else {
      print('İnternet Bağlantısı yok');
      internetConnecitonAlert();
    }
  }

  MapViewState(this.locationModel);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.circle,
                color: _lightColor.kouGreen,
              ),
              onPressed: () {},
            )
          ],
          title: Text(
            "${locationModel.name}",
            style: TextStyle(fontSize: appBarTitleSize),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          centerTitle: true),
      body: !(currentLocations == null)
          ? _googleMapWidget()
          : _googleMapWidgetNoLine(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButtonGoMap(),
    );
  }

  @override
  void dispose() {
    super.dispose();
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

  static final CameraPosition _statringLocation = CameraPosition(
    target: LatLng(_startingCameraLat, _startingCameraLng),
    zoom: _cameraZoom,
  );

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    if (networkConnection) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(startPoint.latitude, startPoint.longitude),
        PointLatLng(finishPoint.latitude, finishPoint.longitude),
        travelMode: TravelMode.walking,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      }
      if (mounted) {
        setState(() {});
      }
    }
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

  GoogleMap _googleMapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: _statringLocation,
      onMapCreated: (GoogleMapController controller) {
        startPoint =
            LatLng(currentLocations!.latitude!, currentLocations!.longitude!);
        finishPoint = LatLng(locationModel.lat!, locationModel.lng!);
        if (currentLocations != null) {
          getPolyPoints();
        }
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
    );
  }

  GoogleMap _googleMapWidgetNoLine() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: _statringLocation,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _createMarker(),
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

  Future<void> _goSelectedLocation(
      {required double lat, required double lng}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: _cameraZoom),
      ),
    );
  }

  void internetConnecitonAlert() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: AlertDialog(
          title: Center(
              child: Icon(
            Icons.wifi_off_outlined,
            size: (MediaQuery.of(context).size.width * 0.2),
            color: _lightColor.cancelRed,
          )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Text(
            networkCheckText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Center(
                  child: Text(
                    "Tamam",
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
