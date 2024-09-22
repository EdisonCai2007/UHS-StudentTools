import 'package:flutter/material.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/themes/themes.dart';

class ThemeManager with ChangeNotifier {
  ThemeData? _themeData;

  ThemeManager() {
    loadThemePreference();
  }

  ThemeData get themeData => _themeData ?? Themes.lightTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleThemeMode() {
    if (_themeData == Themes.lightTheme) {
      themeData = Themes.darkTheme;
      sharedPrefs.isLightTheme = false;
    } else {
      themeData = Themes.lightTheme;
      sharedPrefs.isLightTheme = true;
    }
  }

  Future<void> loadThemePreference() async {
    if (sharedPrefs.isLightTheme) {
      _themeData = Themes.lightTheme;
    } else {
      _themeData = Themes.darkTheme;
    }
    notifyListeners();
  }
}