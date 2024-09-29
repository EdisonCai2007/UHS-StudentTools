import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/screens/teacher_contacts/teacher_contacts_screen.dart';
import 'package:wolfpackapp/screens/courses_screen/courses_screen.dart';
import 'package:wolfpackapp/screens/events_screen/events_screen.dart';
import 'package:wolfpackapp/screens/guidance_screen/guidance_screen.dart';
import 'package:wolfpackapp/screens/home_screen/home_screen.dart';
import 'package:wolfpackapp/screens/login_screen/login_screen.dart';
import 'package:wolfpackapp/screens/resources_screen/resources_screen.dart';
import 'package:wolfpackapp/screens/settings_screen/settings_screen.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';

class MenuDrawer extends Drawer {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon (change later to an actually icon)
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Center(
              child: Text('UHS Wolfpackapp',
                style: GoogleFonts.roboto(
                  fontSize: 30, fontWeight: FontWeight.w900
                ),
              ),
            ),
          ),

          // Home page button
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Home',
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400)),
            onTap: () {
              PageNavigator.changePage(context, const HomeScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.class_),
            title: Text('Courses',
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400)),
            onTap: () {
              PageNavigator.changePage(context, const CoursesScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.contacts),
            title: Text('Teachers',
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400)),
            onTap: () {
              PageNavigator.changePage(context, const ContactTeachersScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.school),
            title: Text('Guidance',
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400)),
            onTap: () {
              PageNavigator.changePage(context, const GuidanceScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.event),
            title: Text('Events',
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400)),
            onTap: () {
              PageNavigator.changePage(context, const EventsScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: Text('Resources',
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400)),
            onTap: () {
              PageNavigator.changePage(context, const ResourcesScreen());
            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                      shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      sharedPrefs.username = '';
                      sharedPrefs.password = '';
                      TeachAssistModel.clearCourses();
                      PageNavigator.changePage(context, const LoginScreen());
                    },
                    child: Icon(sharedPrefs.username != '' ? Icons.logout : Icons.login),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                      shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      PageNavigator.changePage(context, const SettingsScreen());
                    },
                    child: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
