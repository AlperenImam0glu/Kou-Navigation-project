class JsonLocation {
  List<Locations>? locations;

  JsonLocation({this.locations});

  JsonLocation.fromJson(Map<String, dynamic> json) {
    if (json['Locations'] != null) {
      locations = <Locations>[];
      json['Locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.locations != null) {
      data['Locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  String? id;
  String? name;
  double? lat;
  double? lng;

  Locations({this.id, this.name, this.lat, this.lng});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}
