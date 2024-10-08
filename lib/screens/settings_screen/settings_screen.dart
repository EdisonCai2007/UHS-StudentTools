import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';

import '../../menu_drawer.dart';
import '../../themes/theme_manager.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => PageNavigator.backButton(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        /*
      ####################
      #=-=-= AppBar =-=-=#
      ####################
      */
        appBar: AppBar(
          title: Text('Settings', style: GoogleFonts.roboto(fontSize: 20)),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          centerTitle: true,
        ),

        /*
      #########################
      #=-=-= Menu Drawer =-=-=#
      #########################
      */
        drawer: const MenuDrawer(),

        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SwitchListTile(
                  title: Text('Dark Mode',
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w400)),
                  secondary: const Icon(Icons.dark_mode),
                  value: !sharedPrefs.isLightTheme,
                  onChanged: (e) {
                    Provider.of<ThemeManager>(context, listen: false).toggleThemeMode();
                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SwitchListTile(
                  title: Text('Blur Course Overview',
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w400)),
                  secondary: const Icon(Icons.blur_on),
                  value: sharedPrefs.blurCourseOverview,
                  onChanged: (e) {
                    setState(() {
                      sharedPrefs.blurCourseOverview = e;
                    });
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
