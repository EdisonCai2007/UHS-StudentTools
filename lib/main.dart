import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolfpackapp/firebase_options.dart';
import 'package:wolfpackapp/screens/login_screen/login_screen.dart';

import 'themes/theme_manager.dart';

import 'models_services/teachassist_model.dart';
import 'screens/settings_screen/settings_screen.dart';
import 'screens/home_screen/home_screen.dart';

import 'dart:io';


// - 🏁 START HERE 🏁 -
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeManager(),
      child: const MyApp(),
    )
  );
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}


// MyApp Widget; Holds Themes and Pages
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> futureTeachAssistMarks;

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
        '/loginScreen': (context) => const LoginScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/settingsScreen': (context) => const SettingsScreen()
      },
      title: 'UHS Student Tools',

      theme: Provider.of<ThemeManager>(context).themeData,
    );
  }
}
