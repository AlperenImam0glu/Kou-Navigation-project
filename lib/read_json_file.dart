import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class ReadJsonFile {
  Future readJson() async {
    final String response =
        await rootBundle.loadString('assets/locations.json');
    final data = await json.decode(response);
    final locations = data['Locations'];
    return locations;
  }
}
