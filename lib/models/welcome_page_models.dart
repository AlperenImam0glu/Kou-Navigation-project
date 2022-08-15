import 'package:kou_navigation_project/models/location_model.dart';

class WelcomePageModels {
  List<LocationModels> models() {
    List<LocationModels> locationList = [];

    LocationModels yemekhane = LocationModels(
        name: "İletişim Fakültesi", lat: 40.822925, lng: 29.923182);
    LocationModels ogrenciIsleri = LocationModels(
        name: "Eğitim Fakültesi", lat: 40.821848, lng: 29.924389);
    LocationModels muhendislikFakultesi = LocationModels(
        name: "İktisadi Ve İdari Bilimler Fakültesi",
        lat: 40.822373,
        lng: 29.923929);
    LocationModels hukukFakultesi = LocationModels(
        name: "Mühendislik Fakültesi B Kapısı", lat: 40.821870, lng: 29.923585);
    LocationModels kutuphane = LocationModels(
        name: "Mühendislik Fakültesi A Kapısı", lat: 40.820709, lng: 29.922098);
    LocationModels rektorluk = LocationModels(
        name: "Fen Edebiyat Fakültesi A Blok", lat: 40.820983, lng: 29.920250);
    LocationModels kongreMerkezi = LocationModels(
        name: "Fen Edebiyat Fakültesi B Blok", lat: 40.822129, lng: 29.926102);
    LocationModels mediko =
        LocationModels(name: "Hukuk Fakültesi", lat: 40.821768, lng: 29.926135);
    LocationModels golet = LocationModels(
        name: "Teknoloji Fakültesi", lat: 40.821612, lng: 29.920167);
    LocationModels golet2 = LocationModels(
        name: "İlahiyat Fakültesi", lat: 40.812755, lng: 29.920893);

    locationList.add(yemekhane);
    locationList.add(ogrenciIsleri);
    locationList.add(muhendislikFakultesi);
    locationList.add(hukukFakultesi);
    locationList.add(kutuphane);
    locationList.add(rektorluk);
    locationList.add(kongreMerkezi);
    locationList.add(mediko);
    locationList.add(golet);
    locationList.add(golet2);

    return locationList;
  }
}
