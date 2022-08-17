import 'package:url_launcher/url_launcher.dart';

class OpenUrl {
  OpenUrl._();

  static Future<void> openMap(String _url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(_url)) {
      // ignore: deprecated_member_use
      await launch(_url);
    } else {
      print("açılamadı");
    }
  }
}
