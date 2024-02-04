import 'package:flutter/material.dart';


class Themes {
  // Light Theme Colours
  Color lightPrimaryColour = const Color.fromRGBO(255, 255, 255, 1.0);
  Color lightBackgroundColour = const Color.fromRGBO(255, 255, 255, 1.0);
  Color lightAppBar = const Color.fromRGBO(238, 238, 238, 1.0);
  Color lightContainer = const Color.fromRGBO(237, 237, 237, 1.0);
  Color lightAccent = const Color.fromRGBO(210, 8, 8, 1.0);

  // Dark Theme Colours
  Color darkPrimaryColour = const Color.fromRGBO(0, 0, 0, 1.0);
  Color darkBackgroundColour = const Color.fromRGBO(36, 38, 42, 1.0);
  Color darkAppBar = const Color.fromRGBO(23, 23, 23, 1.0);
  Color darkContainer = const Color.fromRGBO(51, 51, 61, 1.0);
  Color darkAccent = const Color.fromRGBO(176, 18, 18, 1.0);

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
      primaryContainer: _themes.lightContainer,
      secondary: _themes.lightAccent,
      background: _themes.lightBackgroundColour,
    ),
    // AppBar Theme
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: _themes.lightAppBar,
        toolbarHeight: 70,
        shape:
            const BorderDirectional(bottom: BorderSide(color: Colors.black))),
    bottomAppBarTheme: BottomAppBarTheme(
      color: _themes.lightAppBar,
      height: 70,
      padding: const EdgeInsets.all(20),
    ),
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
      primaryContainer: _themes.darkContainer,
      secondary: _themes.darkAccent,
      background: _themes.darkBackgroundColour,
    ),
    // AppBar Theme
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: _themes.darkAppBar,
        toolbarHeight: 70,
        shape:
            const BorderDirectional(bottom: BorderSide(color: Colors.black))),
    bottomAppBarTheme: BottomAppBarTheme(
      color: _themes.darkAppBar,
      height: 70,
      padding: const EdgeInsets.all(20),
    ),
  );
}

Themes _themes = Themes();
