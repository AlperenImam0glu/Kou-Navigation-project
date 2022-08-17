import 'package:flutter/material.dart';
import 'package:kou_navigation_project/core/open_url.dart';
import 'package:kou_navigation_project/core/read_json_file.dart';
import 'package:kou_navigation_project/models/json_data.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';
import 'package:kou_navigation_project/views/map_view.dart';
import 'package:kou_navigation_project/views/search_page_view.dart';
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
  final double projectPadding = 20;
  final double sizedBoxHeight = 20;
  final double buttonSize = 90;
  final _lightColor = LightColor();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    getJsonList();
  }

  static List<Locations>? locationList = [];
  List<LocationModels> modelList = [];
  getJsonList() async {
    locationList = await ReadJsonFile()
        .readJsonWithPath("assets/json/welcomePageLocatinos.json");
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
                  child: ListView(children: [
                    modelList.isEmpty == true
                        ? Text("")
                        : Column(
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
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: _lightColor.kouGreen),
              child: Center(child: Image.asset(kouLogoPath)),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    leading: SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        child: Image.asset(
                          "assets/icons/chrome.png",
                        )),
                    title: Text('Web site',
                        style: Theme.of(context).textTheme.subtitle2),
                    onTap: () {
                      OpenUrl.openMap("https://www.kocaeli.edu.tr/");
                    },
                  ),
                  SizedBox(
                    height: sizedBoxHeight,
                  ),
                  ListTile(
                    leading: SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        child: Image.asset("assets/icons/instagram.png")),
                    title: Text("Instagram",
                        style: Theme.of(context).textTheme.subtitle2),
                    onTap: () {
                      OpenUrl.openMap(
                          "https://www.instagram.com/kou92official/");
                    },
                  ),
                  SizedBox(
                    height: sizedBoxHeight,
                  ),
                  ListTile(
                    leading: SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        child: Image.asset("assets/icons/facebook.png")),
                    title: Text("Facebook",
                        style: Theme.of(context).textTheme.subtitle2),
                    onTap: () {
                      OpenUrl.openMap(
                          "https://www.facebook.com/kou92official/");
                    },
                  ),
                  SizedBox(
                    height: sizedBoxHeight,
                  ),
                  ListTile(
                    leading: SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        child: Image.asset("assets/icons/twitter.png")),
                    title: Text("Twitter",
                        style: Theme.of(context).textTheme.subtitle2),
                    onTap: () {
                      OpenUrl.openMap("https://twitter.com/kou92official");
                    },
                  ),
                  SizedBox(
                    height: sizedBoxHeight,
                  ),
                  ListTile(
                    leading: SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        child: Image.asset("assets/icons/youtube.png")),
                    title: Text("Youtube",
                        style: Theme.of(context).textTheme.subtitle2),
                    onTap: () {
                      OpenUrl.openMap(
                          "https://www.youtube.com/c/kocaeli%C3%BCniversitesi");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
      /*leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset(kouLogoPath),
      ),*/
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
          onPressed: () {},
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
          builder: (_) => _aletDialog(location),
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

  AlertDialog _aletDialog(LocationModels location) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: Center(child: Text(aletDialogTextTitle)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      )),
      content: _alertDialogBuilder(location),
      actions: [_alertDialogActions(location)],
    );
  }

  Row _alertDialogActions(LocationModels location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: Text(alertDialogCancel),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(_lightColor.cancelRed)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          child: Text(
            alertDialogAccept,
            style: TextStyle(),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapView(locationModel: location)));
          },
        ),
      ],
    );
  }

  Builder _alertDialogBuilder(LocationModels location) {
    return Builder(
      builder: (context) {
        var width = MediaQuery.of(context).size.width * 0.9;
        return Container(
          //height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              location.name!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
              ),
            ),
          ),
        );
      },
    );
  }
}
