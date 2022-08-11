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

  final textFieldController = TextEditingController();

  final String appBarTitleText = "KOCAELİ ÜNİVERSİTESİ LOKASYONLAR";
  final String searchButtonText = "ARAMA YAPMAK İÇİN DOKUNUN";
  final String aletDialogTextTitle = "Seçilen Lokasyon";
  final String alertDialogAccept = "Konumu Göster";
  final String alertDialogCancel = "İptal";
  final String kouLogoPath = "assets/icons/kou_logo.png";
  final double projectPadding = 20;
  final double sizedBoxHeight = 20;

  @override
  void initState() {
    super.initState();
    //WelcomePageModels().models();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          appBarTitleText,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width / 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: sizedBoxHeight),
              Expanded(child: Image.asset(kouLogoPath)),
              SizedBox(height: sizedBoxHeight),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: projectPadding),
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
                      height: sizedBoxHeight,
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
        searchButtonText,
        style: TextStyle(color: Color.fromARGB(255, 128, 128, 128)),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Color(0xFF0aa351))))),
    );
  }

  Row _singleElevatedButton(String firstText, LocationModels location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _shortcutElevatedButton(location),
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
        _shortcutElevatedButton(firstLocation),
        SizedBox(
          width: 15,
        ),
        _shortcutElevatedButton(secondLocation),
      ],
    );
  }

  ElevatedButton _shortcutElevatedButton(LocationModels location) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ))),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => _aletDialog(location),
        );
      },
      child: Text(location.name!),
    );
  }

  AlertDialog _aletDialog(LocationModels location) {
    return AlertDialog(
      title: Text(aletDialogTextTitle),
      content: Text(
        location.name!,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: projectPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: Text(alertDialogCancel),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 222, 97, 88))),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              ElevatedButton(
                child: Text(alertDialogAccept),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MapView(locationModel: location)));
                },
              )
            ],
          ),
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
