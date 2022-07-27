import 'package:kou_navigation_project/models/location_model.dart';

class WelcomePageModels {
  List<LocationModels> models() {
    List<LocationModels> locationList = [];

    LocationModels yemekhane =
        LocationModels(name: "Yemekhane", lat: 40.821364, lng: 29.927784);
    LocationModels ogrenciIsleri =
        LocationModels(name: "Öğrenci İşleri", lat: 40.821458, lng: 29.928691);
    LocationModels muhendislikFakultesi = LocationModels(
        name: "Muhendislik Fakültesi", lat: 40.8217655, lng: 29.9233853);
    LocationModels hukukFakultesi =
        LocationModels(name: "Hukuk Fakültesi", lat: 40.821731, lng: 29.926083);
    LocationModels kutuphane =
        LocationModels(name: "Kütüphane", lat: 40.821772, lng: 29.921733);
    LocationModels rektorluk =
        LocationModels(name: "Rektörlük", lat: 40.822693, lng: 29.922210);
    LocationModels kongreMerkezi =
        LocationModels(name: "Kongre Merkezi", lat: 40.822423, lng: 29.921349);
    LocationModels mediko =
        LocationModels(name: "Mediko", lat: 40.822255, lng: 29.927764);
    LocationModels golet =
        LocationModels(name: "Gölet", lat: 40.817432, lng: 29.921064);

    locationList.add(yemekhane);
    locationList.add(ogrenciIsleri);
    locationList.add(muhendislikFakultesi);
    locationList.add(hukukFakultesi);
    locationList.add(kutuphane);
    locationList.add(rektorluk);
    locationList.add(kongreMerkezi);
    locationList.add(mediko);
    locationList.add(golet);

    return locationList;
  }
}
