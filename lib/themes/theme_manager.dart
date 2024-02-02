import 'package:flutter/material.dart';
import 'package:wolfpackapp/themes/themes.dart';

class ThemeManager with ChangeNotifier{
  ThemeData _themeData = Themes.darkTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleThemeMode() {
    if (_themeData == Themes.lightTheme) {
      themeData = Themes.darkTheme;
    } else {
      themeData = Themes.lightTheme;
    }
  }
}