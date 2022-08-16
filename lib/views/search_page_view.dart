import 'package:flutter/material.dart';
import 'package:kou_navigation_project/core/read_json_file.dart';
import 'package:kou_navigation_project/models/json_data.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/views/map_view.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';

class SearchPageView extends StatefulWidget {
  SearchPageView({Key? key}) : super(key: key);

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  static List<Locations>? locationList = [];
  static List<Locations>? searchList = [];
  var textFieldController = TextEditingController();
  final String appBarTitleText = "ARAMA";
  final String aletDialogTextTitle = "Seçilen Lokasyon";
  final String alertDialogAccept = "Konumu Göster";
  final String alertDialogCancel = "Seçimi İptal Et";
  final String textFieldTitle = "Arama";
  final String searchFaild = "Bulunamadı";
  final String emptyText = "";
  final double projectPadding = 20;
  final double faildSearchsize = 20;
  final double projectBorderRadius = 20;
  final double listViewIconSize = 35;
  bool focus = true;
  final _lightColor = LightColor();

  getJsonList() async {
    locationList = await ReadJsonFile().readJson();
    searchList = locationList;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getJsonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          appBarTitleText,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: locationList == null
          ? CircularProgressIndicator()
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: projectPadding / 2),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: projectPadding,
                            ),
                            child: _searchTextField(),
                          ),
                        ),
                      ),
                      locationList?.isEmpty == true
                          ? Center(child: CircularProgressIndicator())
                          : Expanded(
                              flex: 7,
                              child: searchList!.length < 1
                                  ? Text(searchFaild,
                                      style: TextStyle(
                                        fontSize: faildSearchsize,
                                      ))
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: projectPadding + 5),
                                      child: _customListView()),
                            ),
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
      autofocus: focus,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
        prefixIcon: Icon(Icons.search_outlined),
        suffixIcon: IconButton(
          onPressed: () {
            textFieldController.text = emptyText;
            setState(() {
              searchList = locationList;
            });
          },
          icon: Icon(Icons.clear),
        ),
        hintText: textFieldTitle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(projectBorderRadius),
        ),
      ),
      onChanged: searchLocation,
    );
  }

  ListView _customListView() {
    return ListView.builder(
      itemCount: searchList!.length,
      itemBuilder: (context, index) {
        final item = searchList![index];
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(projectBorderRadius / 2)),
          color: _lightColor.kouGreen,
          child: ListTile(
            trailing: Icon(
              Icons.assistant_direction_rounded,
              size: listViewIconSize,
              color: Colors.white,
            ),
            title: Text("${item.name}",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                    )),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showDialog(
                context: context,
                builder: (_) => _aletDialog(index),
              );
            },
          ),
        );
      },
    );
  }

  void searchLocation(String query) {
    final suggestion = locationList!.where((element) {
      final name = element.name!.toLowerCase();
      final input = query.toLowerCase();
      if (name.contains(input) == false) {
        return name.contains(input);
      } else {
        return name.contains(input);
      }
    }).toList();
    setState(() {
      searchList = suggestion;
    });
  }

  void _goMapScreen(BuildContext context, int index) {
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

  AlertDialog _aletDialog(int index) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: Center(child: Text(aletDialogTextTitle)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: _alertDialogBuilder(index),
      actions: [_alertDialogActions(index)],
    );
  }

  Builder _alertDialogBuilder(int index) {
    return Builder(
      builder: (context) {
        var width = MediaQuery.of(context).size.width * 0.9;
        return Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              searchList![index].name!,
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

  Row _alertDialogActions(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: Text(alertDialogCancel),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(_lightColor.cancelRed)),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
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
            _goMapScreen(context, index);
          },
        ),
      ],
    );
  }
}
