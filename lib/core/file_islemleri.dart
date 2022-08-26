import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DosyaIslemleri {
  static Future<String> get getDosyaYolu async {
    Directory dosya = await getApplicationDocumentsDirectory();
    return dosya.path;
  }

  static Future get dosyaOlustur async {
    var dosyakonumu = await getDosyaYolu;
    return File(dosyakonumu + "/olusturulandosya.txt");
  }

  static Future dosyaYaz(String dosyaninIcerigi) async {
    var myDosya = await dosyaOlustur;

    return myDosya.writeAsString(dosyaninIcerigi);
  }

  static Future<String> okunacakDosya() async {
    try {
      var myDosya = await dosyaOlustur;
      String dosyaicergi = myDosya.readAsStringSync();
      return dosyaicergi;
    } catch (exception) {
      return ("HATA :$exception");
    }
  }
}
