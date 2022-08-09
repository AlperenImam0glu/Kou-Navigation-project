import 'package:flutter/material.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/models/welcome_page_models.dart';
import 'package:kou_navigation_project/views/map_view.dart';
import 'package:kou_navigation_project/views/search_page_view.dart';

class WelcomePageView extends StatefulWidget {
  WelcomePageView({Key? key}) : super(key: key);

  @override
  State<WelcomePageView> createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  static List<LocationModels> girisSayfasiModelleri =
      WelcomePageModels().models();
  final String titleText = "KOCAELİ ÜNİVERSİTESİ LOKASYONLAR";

  final textFieldController = TextEditingController();

  double width = 0;

  @override
  void initState() {
    super.initState();
    WelcomePageModels().models();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            titleText,
            style: TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 65,
                  width: double.infinity,
                  child: _searchButton(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    _doubleElevatedButton(
                        firstText: "Yemekhane",
                        secondText: "Öğrenci İşleri",
                        firstLocation: girisSayfasiModelleri[
                            LocationNames.Yemekhane.index],
                        secondLocation: girisSayfasiModelleri[
                            LocationNames.OgrenciIsleri.index]),
                    _doubleElevatedButton(
                        firstText: "Mühendislik Fakültesi",
                        secondText: "Hukuk Fakültesi",
                        firstLocation: girisSayfasiModelleri[
                            LocationNames.MuhendislikFakultesi.index],
                        secondLocation: girisSayfasiModelleri[
                            LocationNames.HukukFakultesi.index]),
                    _doubleElevatedButton(
                        firstText: "Kütüphane",
                        secondText: "Rektörlük",
                        firstLocation: girisSayfasiModelleri[
                            LocationNames.Kutuphane.index],
                        secondLocation: girisSayfasiModelleri[
                            LocationNames.Rektorluk.index]),
                    _singleElevatedButton(
                        "Prof. Dr. Baki Komşuoğlu Kongre Merkezi",
                        girisSayfasiModelleri[
                            LocationNames.KongreMerkezi.index]),
                    _doubleElevatedButton(
                      firstText: "Mediko",
                      secondText: "Gölet",
                      firstLocation:
                          girisSayfasiModelleri[LocationNames.Mediko.index],
                      secondLocation:
                          girisSayfasiModelleri[LocationNames.Golet.index],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _searchButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPageView()),
        );
      },
      icon: Icon(
        Icons.search_outlined,
        color: Colors.grey,
      ),
      label: Text(
        "ARAMA YAPMAK İÇİN TIKLAYINIZ",
        style: TextStyle(color: Colors.grey),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green)))),
    );
  }

  Row _singleElevatedButton(String firstText, LocationModels location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapView(locationModel: location)));
          },
          child: Text(firstText),
        ),
      ],
    );
  }

  Row _doubleElevatedButton(
      {required String firstText,
      required String secondText,
      required LocationModels firstLocation,
      required LocationModels secondLocation}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MapView(locationModel: firstLocation)));
          },
          child: Text(firstText),
        ),
        SizedBox(
          width: 15,
        ),
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MapView(locationModel: secondLocation)));
          },
          child: Text(secondText),
        ),
      ],
    );
  }
}

enum LocationNames {
  Yemekhane,
  OgrenciIsleri,
  MuhendislikFakultesi,
  HukukFakultesi,
  Kutuphane,
  Rektorluk,
  KongreMerkezi,
  Mediko,
  Golet
}
