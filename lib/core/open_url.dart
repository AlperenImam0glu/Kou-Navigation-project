import 'package:url_launcher/url_launcher.dart';

class OpenUrl {
  OpenUrl._();

  static Future<bool> openMap(String _url) async {
    try {
// ignore: deprecated_member_use
      await launch(_url);
      return true;
    } catch (e) {
      print("verilen url açılamadı $e");
      return false;
    }
  }
}
