import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kou_navigation_project/location_model.dart';
import 'package:kou_navigation_project/read_json_file.dart';
import 'package:kou_navigation_project/views/map_view.dart';

class WelcomePageView extends StatefulWidget {
  WelcomePageView({Key? key}) : super(key: key);

  @override
  State<WelcomePageView> createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  final String titleText = "KOCAELİ ÜNİVERSİTESİ";
  static LocationModels locationModel = LocationModels();
  static List? items = [];

  void returnjsonh() async {
    var data;
    data = await ReadJsonFile().readJson();

    print(data[0]["Name"]);
  }

  @override
  void initState() {
    super.initState();
    returnjsonh();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(titleText,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Arama',
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _doubleElevatedButton(
                  firstText: "Yemekhane", secondText: "Öğrenci İşerli"),
              _doubleElevatedButton(
                  firstText: "Mühendislik Fakültesi",
                  secondText: "Hukuk Fakültesi"),
              _doubleElevatedButton(
                  firstText: "Kütüphane", secondText: "Rektörlük"),
              _singleElevatedButton("Prof. Dr. Baki Komşuoğlu Kongre Merkezi"),
              _doubleElevatedButton(
                  firstText: "Mediko", secondText: "Rektörlük"),
              _goMapButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Row _singleElevatedButton(String firstText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text(firstText),
        ),
      ],
    );
  }

  Row _doubleElevatedButton(
      {required String firstText, required String secondText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            locationModel = LocationModels(
                name: "Yemekhane", lat: 40.821364, lng: 29.927784);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MapSample(locationModel: locationModel)));
          },
          child: Text(firstText),
        ),
        SizedBox(
          width: 15,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(secondText),
        ),
      ],
    );
  }

  ElevatedButton _goMapButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
      child: Text(
        "Harita",
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: Colors.white),
      ),
      onPressed: () {
        locationModel =
            LocationModels(name: "Yemekhane", lat: 40.821364, lng: 29.927784);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapSample(locationModel: locationModel)));
      },
    );
  }

  Widget _searchButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () {},
      icon: Icon(Icons.search_outlined, size: 40),
      label: Text(
        'Arama',
        style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
