import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Getlocations extends StatefulWidget {
  Getlocations({Key? key}) : super(key: key);

  @override
  State<Getlocations> createState() => _GetlocationsState();
}

class _GetlocationsState extends State<Getlocations> {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool _isListenLocation = false, _isGetLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (_serviceEnabled) return;
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) return;
                }
                _locationData = await location.getLocation();
                setState(() {
                  _isGetLocation = true;
                });
              },
              child: Text("Get location")),
          _isGetLocation
              ? Text(
                  'Location ${_locationData.latitude}/ ${_locationData.longitude}')
              : Text("Konuma erişilemedi"),
          ElevatedButton(
              onPressed: () async {
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (_serviceEnabled) return;
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) return;
                }
                setState(() {
                  _isListenLocation = true;
                });
              },
              child: Text("Listen Location")),
          StreamBuilder(
              stream: location.onLocationChanged,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  var data = snapshot.data as LocationData;
                  return Text(
                      "Location change ${data.latitude}/ ${data.longitude}");
                } else
                  return Center(child: CircularProgressIndicator());
              })
        ],
      ),
    );
  }
}
