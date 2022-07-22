import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kou_navigation_project/map_view.dart';

class WelcomePageView extends StatefulWidget {
  WelcomePageView({Key? key}) : super(key: key);

  @override
  State<WelcomePageView> createState() => _WelcomePageViewState();
}

class _WelcomePageViewState extends State<WelcomePageView> {
  List? _items = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/locations.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["Locations"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KOCAELİ ÜNİVERSİTESİ",
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
              child: Text(
                "Harita",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapSample()));
              },
            ),

            ElevatedButton(
              child: const Text('Load Data'),
              onPressed: readJson,
            ),

            // Display the data loaded from sample.json
            Expanded(
              child: ListView.builder(
                itemCount: _items?.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Text(_items?[index]["Id"]),
                      title: Text(_items?[index]["Name"]),
                      subtitle: Text(_items![index]["Lat"].toString()),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
