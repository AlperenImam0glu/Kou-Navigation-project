import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:kou_navigation_project/core/file_islemleri.dart';

class FirebaseService {
  static fireBasegetData() async {
    const url =
        "https://kounavigationproject-default-rtdb.europe-west1.firebasedatabase.app/.json";
    try {
      Response cevap = await http.get(Uri.parse(url));

      if (cevap.statusCode == 200) {
        print('Api isteği başarılı');
      }

      if (cevap.body.isNotEmpty) {
        yaz(veriyiDuzenle(cevap.body));
      }
    } catch (e) {}
  }

  static String veriyiDuzenle(String response) {
    //Json verinin başında ve sonundaki fazlalık karakterleri atan fonksiyon.
    int sayac = 0;
    int first = 0;
    int last = response.length - 1;
    for (int i = 0; i < response.length; i++) {
      if (response[i] == "{") {
        sayac += 1;
        if (sayac == 2) {
          first = i;
          break;
        }
      }
    }
    return response.substring(first, last);
  }

  static void yaz(String veri) async {
    DosyaIslemleri.dosyaYaz(veri).then((value) {});
  }
}
