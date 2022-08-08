import 'package:flutter/material.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/models/welcome_page_models.dart';
import 'package:kou_navigation_project/core/read_json_file.dart';
import 'package:kou_navigation_project/views/map_view.dart';
import '../models/json_data.dart';

class WelcomePageView extends StatefulWidget {
  WelcomePageView({Key? key}) : super(key: key);

  @override
  State<WelcomePageView> createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  static List<LocationModels> girisSayfasiModelleri =
      WelcomePageModels().models();
  final String titleText = "KOCAELİ ÜNİVERSİTESİ LOKASYONLAR";
  static List<Locations>? locationList = [];
  final textFieldController = TextEditingController();
  static List<Locations>? searchList = [];
  bool _isVisiable = false;
  double width = 0;

  returnjsonh() async {
    locationList = await ReadJsonFile().readJson();
    /* for (var element in locationList!) {
      print("${element.name}, ${element.lat}, ${element.lng}");
    }*/
    searchList = locationList;
    setState(() {});
  }

  void _changeVisiableFalse() {
    setState(() {
      _isVisiable = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _changeVisiableTrue() {
    setState(() {
      _isVisiable = true;
    });
  }

  @override
  void initState() {
    super.initState();

    print(width);
    WelcomePageModels().models();
    returnjsonh();
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
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _changeVisiableFalse(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _searchTextField(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _isVisiable
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                Visibility(
                  visible: _isVisiable,
                  child: Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: _customListView()),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
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
                // _goMapButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _searchTextField() {
    return TextField(
      controller: textFieldController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search_outlined),
        hintText: 'Arama',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black)),
      ),
      onChanged: searchLocation,
      onTap: _changeVisiableTrue,
    );
  }

  ListView _customListView() {
    return ListView.builder(
      itemCount: searchList!.length,
      itemBuilder: (context, index) {
        final item = searchList![index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.grey[500],
          child: ListTile(
            trailing: const Icon(
              Icons.assistant_direction_rounded,
              size: 35,
              color: Colors.black,
            ),
            title: Text(
              "${item.name}",
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () {
              pushToGoogleMaps(context, index);
            },
          ),
        );
      },
    );
  }

  void pushToGoogleMaps(BuildContext context, int index) {
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapView(
                      locationModel: LocationModels(
                    name: searchList![index].name,
                    lat: searchList![index].lat,
                    lng: searchList![index].lng,
                  ))));
    } catch (e) {}
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

  void searchLocation(String query) {
    final suggestion = locationList!.where((element) {
      final name = element.name!.toLowerCase();
      final input = query.toLowerCase();
      if (_isVisiable == false) {
        _changeVisiableTrue();
      }
      if (name.contains(input) == false) {
        print("aranan bulunmamadı");
        return name.contains(input);
      } else {
        return name.contains(input);
      }
    }).toList();

    setState(() {
      searchList = suggestion;
    });
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
