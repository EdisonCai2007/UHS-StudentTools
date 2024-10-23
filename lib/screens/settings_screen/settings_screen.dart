import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/src/features/updates/data/updates_repository.dart';

import '../../misc/menu_drawer.dart';
import '../../src/features/updates/presentation/optional_update_card.dart';
import '../../themes/theme_manager.dart';

import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;


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
          shape: const Border(
            bottom: BorderSide(color: Colors.transparent),
          ),
        ),

        /*
      #########################
      #=-=-= Menu Drawer =-=-=#
      #########################
      */
        drawer: const MenuDrawer(),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      provider.Provider.of<ThemeManager>(context, listen: false).toggleThemeMode();
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

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Built By: ',
                          style: GoogleFonts.roboto(
                            fontSize: 13, fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),

                        Text('Moxin Guo & Edison Cai',
                          style: GoogleFonts.roboto(
                            fontSize: 13, fontWeight: FontWeight.w300,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),

                    const Padding(padding: EdgeInsets.only(bottom: 5)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Current Build Version: ',
                          style: GoogleFonts.roboto(
                            fontSize: 13, fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),

                        riverpod.Consumer(builder: (context, ref, child) {
                          final AsyncValue<String> currentVersion = ref.watch(deviceVersionProvider);

                          return currentVersion.when(
                              data: (value) {
                                return Text(value,
                                  style: GoogleFonts.roboto(
                                    fontSize: 13, fontWeight: FontWeight.w300,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                );
                              },
                              error: (e, st) {
                                return Expanded(
                                  child: Text('$e',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: 13, fontWeight: FontWeight.w300,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  ),
                                );
                              },
                              loading: () {
                                return CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.secondary,
                                );
                              }
                          );
                        }),

                        riverpod.Consumer(builder: (context, ref, child) {
                          final AsyncValue<String> currentBuild = ref.watch(deviceBuildProvider);

                          return currentBuild.when(
                              data: (value) {
                                return Text('.$value',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13, fontWeight: FontWeight.w300,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                );
                              },
                              error: (e, st) {
                                return Expanded(
                                  child: Text('$e',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13, fontWeight: FontWeight.w300,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                  ),
                                );
                              },
                              loading: () {
                                return CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.secondary,
                                );
                              }
                          );
                        }),
                      ],
                    ),

                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),

              const OptionalUpdateCard(),
            ],
          ),
        ),
      ),
    );
  }
}
