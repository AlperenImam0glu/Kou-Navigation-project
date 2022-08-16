import 'package:flutter/material.dart';

class LighTheme {
  final _lightColor = LightColor();

  late ThemeData theme;

  LighTheme() {
    theme = ThemeData(
      appBarTheme: const AppBarTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      scaffoldBackgroundColor: Color(0xFFfbfbfb),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF009e49)),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
            onPrimary: Color(0xFF009e49), onSecondary: _lightColor.blueMenia),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF009e49),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            subtitle1: TextStyle(fontSize: 25, color: _lightColor._textColor),
          ),
    );
  }
}

class LightColor {
  final Color _textColor = Color.fromARGB(255, 0, 0, 0);
  final Color blueMenia = const Color.fromARGB(95, 188, 248, 1);
  var kouGreen = Color(0xFF009e49);
  var cancelRed = Color(0xFF9e1200);
  //static Color kouGreen = const Color(0xFF0aa351);
  //0xFF009e49
  //0xFFcdb866
  //0xFF231f20
}
