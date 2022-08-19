import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Hesap extends StatefulWidget {
  Hesap({
    Key? key,
  }) : super(key: key);
  @override
  State<Hesap> createState() => _HesapState();
}

class _HesapState extends State<Hesap> {
  List<LatLng> lokasyonlar = [
    LatLng(40.82312, 29.92531),
    LatLng(40.8223, 29.92529),
    LatLng(40.82194, 29.9253),
    LatLng(40.82178, 29.92528),
    LatLng(40.82144, 29.92527),
    LatLng(40.82131, 29.92523),
    LatLng(40.82117, 29.92512),
    LatLng(40.82079, 29.92462),
    LatLng(40.82067, 29.92439),
    LatLng(40.82064, 29.92427),
    LatLng(40.82061, 29.92388),
    LatLng(40.82061, 29.92363),
    LatLng(40.82062, 29.92299),
    LatLng(40.8206, 29.92292),
    LatLng(40.82048, 29.92271),
    LatLng(40.8203, 29.92252),
    LatLng(40.82031, 29.92207),
    LatLng(40.82032, 29.922),
    LatLng(40.82033, 29.92195),
    LatLng(40.82085, 29.92129),
    LatLng(40.82091, 29.92109),
    LatLng(40.82096, 29.92098),
    LatLng(40.82141, 29.92036)
  ];

  veriler() {
    for (int i = 0; i < lokasyonlar.length; i++) {
      pointleriEkle((lokasyonlar[i]));
    }
    // print(points);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    veriler();
    cizgiler();
    print(yol.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Çizilen Yol"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              // Text(widget.durakVerileri.toString()),
              Expanded(
                child: mapWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FlutterMap mapWidget() {
    return new FlutterMap(
      options: new MapOptions(
          minZoom: 1.0, center: new LatLng(40.820992, 29.922347), maxZoom: 18),
      layers: [
        new TileLayerOptions(
          urlTemplate: 'http://mt{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          subdomains: ['0', '1', '2', '3'],
        ),
        new PolylineLayerOptions(
          polylines: yol,
        ),
      ],
    );
  }

  static var points = <LatLng>[];
  pointleriEkle(LatLng nokta) {
    double lat = nokta.latitude;
    double long = nokta.longitude;
    points.add(LatLng(lat, long));
  }

  static List<Polyline> yol = [];
  cizgiler() {
    var cizgi = <Polyline>[];

    Polyline polyline =
        new Polyline(points: (points), strokeWidth: 2.0, color: Colors.red);

    yol.add(polyline);
  }
}
