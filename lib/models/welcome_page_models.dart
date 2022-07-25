import 'package:kou_navigation_project/models/location_model.dart';

class WelcomePageModels {
  List<LocationModels> models() {
    List<LocationModels> locationList = [];

    LocationModels Yemekhane =
        LocationModels(name: "Yemekhane", lat: 40.821364, lng: 29.927784);
    LocationModels OgrenciIsleri =
        LocationModels(name: "Yemekhane", lat: 40.8211797, lng: 29.9275619);
    LocationModels MuhendislikFakultesi =
        LocationModels(name: "Yemekhane", lat: 40.8217655, lng: 29.9233853);
    LocationModels HukukFakultesi =
        LocationModels(name: "Yemekhane", lat: 40.821731, lng: 29.926083);
    LocationModels Kutuphane =
        LocationModels(name: "Yemekhane", lat: 40.821772, lng: 29.921733);
    LocationModels Rektorluk =
        LocationModels(name: "Yemekhane", lat: 40.822693, lng: 29.922210);
    LocationModels KongreMerkezi =
        LocationModels(name: "Yemekhane", lat: 40.822423, lng: 29.921349);
    LocationModels Mediko =
        LocationModels(name: "Yemekhane", lat: 40.822255, lng: 29.927764);
    LocationModels Golet =
        LocationModels(name: "Yemekhane", lat: 40.817432, lng: 29.921064);

    locationList.add(Yemekhane);
    locationList.add(OgrenciIsleri);
    locationList.add(MuhendislikFakultesi);
    locationList.add(HukukFakultesi);
    locationList.add(Kutuphane);
    locationList.add(Rektorluk);
    locationList.add(KongreMerkezi);
    locationList.add(Mediko);
    locationList.add(Golet);

    return locationList;
  }
}
