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
            onPrimary: Colors.green, onSecondary: _lightColor.blueMenia),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color.fromARGB(255, 52, 160, 45),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            subtitle1: TextStyle(fontSize: 25, color: _lightColor._textColor),
          ),
    );
  }
}

class _LightColor {
  final Color _textColor = Color.fromARGB(255, 247, 152, 152);
  final Color blueMenia = const Color.fromARGB(95, 188, 248, 1);
}
