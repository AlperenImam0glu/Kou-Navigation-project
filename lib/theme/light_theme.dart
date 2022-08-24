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
      scaffoldBackgroundColor: _lightColor.scaffoldBackground,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: _lightColor.kouGreen),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
          onPrimary: _lightColor.kouGreen,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: _lightColor.kouGreen,
      ),
      drawerTheme: DrawerThemeData(),
      textTheme: ThemeData.light().textTheme.copyWith(
            subtitle1: TextStyle(fontSize: 25),
          ),
    );
  }
}

class LightColor {
  var kouGreen = Color(0xFF009e49);
  var cancelRed = Color(0xFF9e1200);
  var scaffoldBackground = Color(0xFFfbfbfb);
  var kouBlack = Color(0xFF231f20);
}
