import 'package:flutter/material.dart';

class LighTheme {
  final _lightColor = _LightColor();

  late ThemeData theme;

  LighTheme() {
    theme = ThemeData(
      appBarTheme: const AppBarTheme(
        // color: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.white.withOpacity(0.9),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.green),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(
            onPrimary: Color.fromRGBO(76, 175, 80, 1),
            onSecondary: _lightColor.blueMenia),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color.fromRGBO(52, 160, 45, 1),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            subtitle1: TextStyle(fontSize: 25, color: _lightColor._textColor),
          ),
    );
  }
}

class _LightColor {
  final Color _textColor = Color.fromARGB(255, 0, 0, 0);
  final Color blueMenia = const Color.fromARGB(95, 188, 248, 1);
}
