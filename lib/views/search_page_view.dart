import 'package:flutter/material.dart';
import 'package:kou_navigation_project/core/read_json_file.dart';
import 'package:kou_navigation_project/models/json_data.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/views/map_view.dart';

class SearchPageView extends StatefulWidget {
  SearchPageView({Key? key}) : super(key: key);

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  static List<Locations>? locationList = [];
  static List<Locations>? searchList = [];

  var textFieldController = TextEditingController();

  final String appBarTitleText = "ARAMA EKRANI";
  final String aletDialogTextTitle = "Seçilen Lokasyon";
  final String alertDialogAccept = "Konuma Git";
  final String alertDialogCancel = "İptal";
  final String textFieldTitle = "Arama";
  final String searchFaild = "Bulunamadı";
  final double projectPadding = 20;

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
      appBar: AppBar(
        title: Text(appBarTitleText),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: projectPadding / 2),
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
                  SizedBox(
                    height: projectPadding / 2,
                  ),
                  locationList?.isEmpty == true
                      ? CircularProgressIndicator()
                      : Expanded(
                          flex: 7,
                          child: searchList!.length < 1
                              ? Text(searchFaild,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: _customListView()),
                        ),
                ],
              ),
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
        suffixIcon: IconButton(
          onPressed: () {
            textFieldController.text = "";
            setState(() {
              searchList = locationList;
            });
          },
          icon: Icon(Icons.clear),
        ),
        hintText: textFieldTitle,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black)),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Color.fromARGB(255, 168, 202, 184),
          child: ListTile(
            trailing: const Icon(
              Icons.assistant_direction_rounded,
              size: 35,
              color: Color(0xFF231f20),
            ),
            title: Text(
              "${item.name}",
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Color(0xFF231f20),
                  ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => _aletDialog(index),
              );

              //
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

  AlertDialog _aletDialog(int index) {
    return AlertDialog(
      title: Text(aletDialogTextTitle),
      content: Text(
        searchList![index].name!,
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
                  pushToGoogleMaps(context, index);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
