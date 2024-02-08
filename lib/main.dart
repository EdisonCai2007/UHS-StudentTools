import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/theme_manager.dart';

import 'model_teachassist.dart';
import 'screens/settings_screen/settings_screen.dart';
import 'screens/home_screen/home_screen.dart';


// - 🏁 START HERE 🏁 -
void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeManager(),
      child: const MyApp(),
    )
  );
}



// MyApp Widget; Holds Themes and Pages
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<TeachAssistMarks> futureTeachAssistMarks;

  @override
  void initState() {
    super.initState();
    futureTeachAssistMarks = fetchMarks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const HomeScreen(),
      routes: {
        '/homeScreen': (context) => const HomeScreen(),
        '/settingsScreen': (context) => const SettingsScreen()
      },
      title: 'UHS App',

      theme: Provider.of<ThemeManager>(context).themeData,
    );
  }
}
