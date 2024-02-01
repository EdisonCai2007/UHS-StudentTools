import 'package:flutter/material.dart';
import 'themes/themes.dart';
import 'home_screen.dart';

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
      home: const HomeScreen(),
      title: 'Home',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
