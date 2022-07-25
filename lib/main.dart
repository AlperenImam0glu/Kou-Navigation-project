import 'package:flutter/material.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';
import 'package:kou_navigation_project/views/welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LighTheme().theme,
      title: 'Flutter Google Maps',
      home: WelcomePageView(),
    );
  }
}
