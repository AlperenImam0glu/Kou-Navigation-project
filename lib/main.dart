import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';
import 'package:kou_navigation_project/views/welcome_page_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LighTheme().theme,
      title: 'Kocaeli Üniversitesi Lokasyonlar',
      home: WelcomePageView(),
    );
  }
}
