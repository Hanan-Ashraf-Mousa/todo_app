import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  String currentLangCode = 'en';

  changeLanguage(newLang) {
    currentLangCode = newLang;
    notifyListeners();
  }
}
