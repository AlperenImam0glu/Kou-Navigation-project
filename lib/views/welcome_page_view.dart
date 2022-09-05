import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kou_navigation_project/core/firebase_service.dart';
import 'package:kou_navigation_project/core/read_json_file.dart';
import 'package:kou_navigation_project/models/json_data.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';
import 'package:kou_navigation_project/views/qr_scanner_view.dart';
import 'package:kou_navigation_project/views/search_page_view.dart';
import 'package:kou_navigation_project/widgets/custom_alert_dialog_widget.dart';
import 'package:kou_navigation_project/widgets/cutom_drawer_widget.dart';
import 'package:location/location.dart';

class WelcomePageView extends StatefulWidget {
  WelcomePageView({Key? key}) : super(key: key);

  @override
  State<WelcomePageView> createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  final textFieldController = TextEditingController();
  final String appBarTitleText = "KOCAELİ ÜNİVERSİTESİ LOKASYONLARI";
  final String searchButtonText = "ARAMA YAPMAK İÇİN DOKUNUN";
  final String aletDialogTextTitle = "Seçilen Lokasyon";
  final String alertDialogAccept = "Konumu Göster";
  final String alertDialogCancel = "Seçimi İptal Et";
  final String kouLogoPath = "assets/icons/kou_pin_logo.png";
  final String welcomePageObjetsPath = "assets/json/welcomePageLocatinos.json";
  final double projectPadding = 20;
  final double sizedBoxHeight = 20;
  final double buttonSize = 90;
  final String networkCheckText = "Devam etmek için internet bağlantısını açın";
  final _lightColor = LightColor();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool networkConnection = false;
  static List<Locations>? locationList = [];
  List<LocationModels> modelList = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getJsonList();
    checkNetworkWithAlert();
  }

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {});
  }

  void checkNetworkWithAlert() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('İnternet Bağlantısı var');
      networkConnection = true;
    } else {
      print('İnternet Bağlantısı yok');
      internetConnecitonAlert();
    }
  }

  void checkNetwork() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('İnternet Bağlantısı var');
      networkConnection = true;
      setState(() {});
    } else {
      print('İnternet Bağlantısı yok');
    }
  }

  getJsonList() async {
    locationList = await ReadJsonFile().readJsonWithPath(welcomePageObjetsPath);
    modelList = listToModel(locationList!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: _customAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                MediaQuery.of(context).size.height > 850
                    ? SizedBox(
                        height: 30,
                      )
                    : SizedBox(),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: projectPadding),
                    child: Container(
                      width: double.infinity,
                      child: _searchButton(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: modelList.isEmpty == true
                      ? Container(
                          width: 300, child: CircularProgressIndicator())
                      : ListView(children: [
                          Column(
                            children: [
                              _doubleElevatedButton(
                                firstLocation: modelList[0],
                                secondLocation: modelList[1],
                              ),
                              SizedBox(height: 10),
                              _doubleElevatedButton(
                                firstLocation: modelList[2],
                                secondLocation: modelList[3],
                              ),
                              SizedBox(height: 10),
                              _doubleElevatedButton(
                                firstLocation: modelList[4],
                                secondLocation: modelList[5],
                              ),
                              SizedBox(height: 10),
                              _doubleElevatedButton(
                                firstLocation: modelList[6],
                                secondLocation: modelList[7],
                              ),
                              SizedBox(height: 10),
                              _doubleElevatedButton(
                                firstLocation: modelList[8],
                                secondLocation: modelList[9],
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
      drawer: CustomDrawer(),
    );
  }

  List<LocationModels> listToModel(List<Locations> locationList) {
    List<LocationModels> models = [];
    for (var element in locationList) {
      LocationModels model = LocationModels();
      model.name = element.name;
      model.lat = element.lat;
      model.lng = element.lng;
      models.add(model);
    }
    return models;
  }

  AppBar _customAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Image.asset(
          kouLogoPath,
        ),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRCodeScannerView(),
            ));
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
    );
  }

  ElevatedButton _searchButton() {
    return ElevatedButton.icon(
      onPressed: () async {
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

  Row _doubleElevatedButton(
      {required LocationModels firstLocation,
      required LocationModels secondLocation}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _customElevatedButton(firstLocation),
        SizedBox(
          width: 15,
        ),
        _customElevatedButton(secondLocation),
      ],
    );
  }

  ElevatedButton _customElevatedButton(LocationModels location) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ))),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => CustomAlertDialog(
            location: location,
            context: context,
          ),
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 70,
        height: MediaQuery.of(context).size.width / 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              location.name!,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  internetConnecitonAlert() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext builderContext) {
          var counter = 240;
          Timer.periodic(const Duration(seconds: 1), (timer) {
            if (networkConnection == true) {
              FirebaseService.fireBasegetData();
              Navigator.of(context, rootNavigator: true).pop();
              timer.cancel();
            }
            checkNetwork();
            if (counter == 0) {
              timer.cancel();
            }
            counter--;
          });

          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: Center(
                  child: Icon(
                Icons.wifi_off_outlined,
                size: (MediaQuery.of(context).size.width * 0.2),
                color: _lightColor.cancelRed,
              )),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              content: Text(
                networkCheckText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                ),
              ),
              actions: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CircularProgressIndicator(),
                )),
              ],
            ),
          );
        });
  }
}