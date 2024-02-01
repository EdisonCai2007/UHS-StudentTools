import 'package:flutter/material.dart';
import 'package:wolfpackapp/screens/settings_screen.dart';
import 'themes/themes.dart';
import 'screens/home_screen.dart';

// 🏁 START HERE 🏁
void main() {
  runApp(const MyApp());
}

// MyApp Widget; Holds Themes and Pages
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const HomeScreen(),
      routes: {
        '/homeScreen': (context) => const HomeScreen(),
        '/settingsScreen': (context) => const SettingsScreen()
      },

      title: 'Home',

      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
