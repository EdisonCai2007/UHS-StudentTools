import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wolfpackapp/models_services/account_model.dart';
import 'package:wolfpackapp/models_services/club_announcements_model.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/models_services/uhs_teachers_model.dart';
import 'package:wolfpackapp/screens/guidance_screen/appointment_list.dart';
import 'package:wolfpackapp/screens/resources_screen/resources_screen.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/src/features/updates/data/updates_repository.dart';
import 'package:wolfpackapp/src/features/updates/domain/update_status.dart';
import 'package:wolfpackapp/src/features/updates/presentation/mandatory_update_screen.dart';
import 'package:wolfpackapp/themes/theme_manager.dart';

import 'screens/settings_screen/settings_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'package:wolfpackapp/screens/teacher_contacts/teacher_contacts_screen.dart';
import 'package:wolfpackapp/screens/courses_screen/courses_screen.dart';
import 'package:wolfpackapp/screens/guidance_screen/guidance_screen.dart';
import 'package:wolfpackapp/screens/login_screen/login_screen.dart';
import 'package:wolfpackapp/screens/events_screen/events_screen.dart';

import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'dart:io';

// - 🏁 START HERE 🏁 -
Future main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  await sharedPrefs.init();
  if (sharedPrefs.username != '' && sharedPrefs.password != '') {
    await TeachAssistModel().init();
    
    void _initAppointmentList() async {
      await initAppointmentList(30);
    }
    _initAppointmentList();
  }

  await UHSTeachersModel().init();
  await ClubAnnouncementsModel().init();
  await AccountModel().init();

  runApp(
      riverpod.ProviderScope(
          child: provider.ChangeNotifierProvider(
            create: (context) => ThemeManager(),
            child: MyApp(),
          )
      )
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// MyApp Widget; Holds Themes and Pages
/*
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}*/

class MyApp extends riverpod.ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, riverpod.WidgetRef ref) {
    final updateStatusValue = ref.watch(deviceUpdateStatusProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: updateStatusValue.when(
          data: (updateStatus) {
            if (updateStatus == UpdateStatus.mandatory) {
              return const MandatoryUpdateScreen();
            }

            return (sharedPrefs.username == '' && sharedPrefs.password == '')
                ? const LoginScreen()
                : const HomeScreen();
          },
          error: (e, s) => const Center(
            child: Text(
              'Sorry, there was a problem with loading the app, please try again later!'
            ),
          ),
          loading: () => CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
      ),
      routes: {
        '/loginScreen': (context) => const LoginScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/contactTeachersScreen': (context) => const ContactTeachersScreen(),
        '/guidanceScreen': (context) => const GuidanceScreen(),
        '/coursesScreen': (context) => const CoursesScreen(),
        '/resourcesScreen': (context) => const ResourcesScreen(),
        '/settingsScreen': (context) => const SettingsScreen(),
        '/eventsScreen': (context) => const EventsScreen(),
      },
      title: 'UHS Wolfpackapp',
      theme: provider.Provider.of<ThemeManager>(context).themeData,
    );
  }
}