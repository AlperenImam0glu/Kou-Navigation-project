import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kou_navigation_project/models/json_data.dart';

class ReadJsonFile {
  String filePath = "assets/locations.json";
  Future readJson() async {
    final String response = await rootBundle.loadString(filePath);
    final data = await json.decode(response);

    JsonLocation jsonConverter = JsonLocation();

    jsonConverter.fromJson(data);
    List<Locations>? locationList = jsonConverter.getLocationList();

    return locationList;
  }

  Future readJsonWithPath(String filePath) async {
    final String response = await rootBundle.loadString(filePath);
    final data = await json.decode(response);

    JsonLocation jsonConverter = JsonLocation();

    jsonConverter.fromJson(data);
    List<Locations>? locationList = jsonConverter.getLocationList();

    return locationList;
  }
}
