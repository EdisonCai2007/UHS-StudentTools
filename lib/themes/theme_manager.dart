import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolfpackapp/themes/themes.dart';

class ThemeManager with ChangeNotifier {
  late ThemeData _themeData;

  ThemeManager() {
    loadThemePreference();
  }

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

    saveThemePreference();
  }

  Future<void> loadThemePreference() async {
    SharedPreferences themePreference = await SharedPreferences.getInstance();
    if (themePreference.getBool('isLightTheme') ?? true) {
      _themeData = Themes.lightTheme;
    } else {
      _themeData = Themes.darkTheme;
    }

    notifyListeners();
  }

  Future<void> saveThemePreference() async {
    SharedPreferences themePreference = await SharedPreferences.getInstance();
    await themePreference.setBool('isLightTheme', _themeData == Themes.lightTheme);
  }
}