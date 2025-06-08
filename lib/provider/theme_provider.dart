import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  var currentTheme = ThemeMode.light;

  changeMode(ThemeMode newMode) {
    currentTheme = newMode;
    notifyListeners();
  }
}
