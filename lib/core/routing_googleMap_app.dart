import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String _url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    // ignore: deprecated_member_use
    if (await canLaunch(_url)) {
      // ignore: deprecated_member_use
      await launch(_url);
    } else {
      print("harita açılamadı");
    }
  }
}
