import 'package:flutter/material.dart';
import 'package:kou_navigation_project/models/location_model.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';
import 'package:kou_navigation_project/views/map_view.dart';

final String aletDialogTextTitle = "Seçilen Lokasyon";
final String alertDialogAccept = "Konumu Göster";
final String alertDialogCancel = "Seçimi İptal Et";
final double buttonSize = 90;
final _lightColor = LightColor();

class CustomAlertDialog extends StatefulWidget {
  CustomAlertDialog({Key? key, required this.location, required this.context})
      : super(key: key);
  final LocationModels location;
  final BuildContext context;

  @override
  State<CustomAlertDialog> createState() =>
      _CustomAlertDialogState(location, context);
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  var location;
  var context;

  _CustomAlertDialogState(this.location, this.context);

  @override
  Widget build(BuildContext context) {
    return _aletDialog(this.location, context);
  }
}

AlertDialog _aletDialog(LocationModels location, BuildContext context) {
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
    actions: [_alertDialogActions(location, context)],
  );
}

void goMapScreen(BuildContext context, LocationModels location) {
  try {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapView(
                    locationModel: LocationModels(
                  name: location.name,
                  lat: location.lat,
                  lng: location.lng,
                ))));
  } catch (e) {}
}

Row _alertDialogActions(LocationModels location, BuildContext context) {
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
          goMapScreen(context, location);
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
