import 'package:flutter/material.dart';

class Themes {
  // Light Theme Colours
  Color lightPrimaryColour = const Color.fromRGBO(255, 255, 255, 1.0);
  Color lightBackgroundColour = const Color.fromRGBO(255, 255, 255, 1.0);
  Color lightAppBar = const Color.fromRGBO(238, 238, 238, 1.0);

  // Dark Theme Colours
  Color darkPrimaryColour = const Color.fromRGBO(0, 0, 0, 1.0);
  Color darkBackgroundColour = const Color.fromRGBO(47, 47, 47, 1.0);
  Color darkAppBar = const Color.fromRGBO(23, 23, 23, 1.0);
  Color darkAccent = const Color.fromRGBO(36, 36, 37, 1.0);

  /*
  ##################################
  #=-=-= Light Mode ThemeData =-=-=#
  ##################################
  */
  static ThemeData lightTheme = ThemeData(
    // Main Colours
    useMaterial3: false,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themes.lightPrimaryColour,
      background: _themes.lightBackgroundColour,
    ),
    // AppBar Theme
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: _themes.lightAppBar,
        toolbarHeight: 70,
        shape:
        const BorderDirectional(bottom: BorderSide(color: Colors.black))),
  );

  /*
  #################################
  #=-=-= Dark Mode ThemeData =-=-=#
  #################################
  */
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themes.darkPrimaryColour,
      background: _themes.darkBackgroundColour,
    ),
    // AppBar Theme
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: _themes.darkAppBar,
        toolbarHeight: 70,
        shape:
        const BorderDirectional(bottom: BorderSide(color: Colors.black))),
  );
}

Themes _themes = Themes();