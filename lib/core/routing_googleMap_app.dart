import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    var httpsUri = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: '/maps/search/?api=1&query=',
        fragment: '$latitude,$longitude');
    print("============================");
    print(httpsUri);
    Uri _url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    print(_url);
    print("============================");
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not open the map.';
    }
  }
}
