import 'package:flutter/material.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/models/welcome_page_models.dart';
import 'package:kou_navigation_project/views/map_view.dart';
import 'package:kou_navigation_project/views/search_page_view.dart';
import 'package:location/location.dart';

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

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(kouLogoPath),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
        title: Text(
          textAlign: TextAlign.center,
          maxLines: 2,
          appBarTitleText,
          style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width - 50) /
                (appBarTitleText.length - 10),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: projectPadding / 2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: projectPadding, vertical: projectPadding),
                    child: Container(
                      width: double.infinity,
                      child: _searchButton(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ListView(children: [
                    Column(
                      children: [
                        _doubleElevatedButton(
                            firstLocation: girisSayfasiModelleri[
                                LocationNames.Yemekhane.index],
                            secondLocation: girisSayfasiModelleri[
                                LocationNames.OgrenciIsleri.index]),
                        SizedBox(height: 10),
                        _doubleElevatedButton(
                            firstLocation: girisSayfasiModelleri[
                                LocationNames.Kutuphane.index],
                            secondLocation: girisSayfasiModelleri[
                                LocationNames.HukukFakultesi.index]),
                        SizedBox(height: 10),
                        _doubleElevatedButton(
                            firstLocation: girisSayfasiModelleri[
                                LocationNames.Rektorluk.index],
                            secondLocation: girisSayfasiModelleri[
                                LocationNames.KongreMerkezi.index]),
                        SizedBox(height: 10),
                        _doubleElevatedButton(
                            firstLocation: girisSayfasiModelleri[
                                LocationNames.MuhendislikFakultesi.index],
                            secondLocation: girisSayfasiModelleri[
                                LocationNames.IlahiyatFakultesi.index]),
                        SizedBox(height: 10),
                        _doubleElevatedButton(
                          firstLocation:
                              girisSayfasiModelleri[LocationNames.Mediko.index],
                          secondLocation:
                              girisSayfasiModelleri[LocationNames.Golet.index],
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
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

  Row _singleElevatedButton({required LocationModels firstLocation}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _shortcutElevatedButton(firstLocation),
      ],
    );
  }

  Row _doubleElevatedButton(
      {required LocationModels firstLocation,
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
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 70,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              location.name!,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
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
  Golet,
  IlahiyatFakultesi
}
