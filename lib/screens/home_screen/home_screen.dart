import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/menu_drawer.dart';
import 'home_screen_containers/welcome_container.dart';

import 'home_screen_containers/daily_weather_overview_container.dart';
import 'home_screen_containers/schedule_overview_container.dart';
import 'home_screen_containers/teachassist_overview_container.dart';

/*
########################
#=-=-= HomeScreen =-=-=#
########################
*/

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      /*
      ####################
      #=-=-= AppBar =-=-=#
      ####################
      */
      appBar: AppBar(
        title: Text('Home', style: GoogleFonts.roboto(fontSize: 20)),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
      ),

      /*
      ###################################
      #=-=-= Bottom Navigation Bar =-=-=#
      ###################################
      */
      // bottomNavigationBar: BottomAppBar(
      //   shadowColor: Colors.black,
      //   child: Center(
      //     child: Text(
      //       'Nav Bar Placeholder Text',
      //       style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      //     ),
      //   ),
      // ),

      /*
      #########################
      #=-=-= Menu Drawer =-=-=#
      #########################
      */
      drawer: const MenuDrawer(),

      /*
      #######################
      #=-=-=-=-=-=-=-=-=-=-=#
      #=-=-= Main Body =-=-=#
      #=-=-=-=-=-=-=-=-=-=-=#
      #######################
      */
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: ScrollController(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -250,
              right: -120,
              child: Platform.isAndroid ? Container(
                height: 600,
                width: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.secondary,
                        blurRadius: 150,
                        blurStyle: BlurStyle.outer)
                  ],
                ),
              ) :
              Stack(
                children: [ 
                  Container(
                    height: 600,
                    width: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.secondary,
                            blurRadius: 50,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 600,
                    width: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.background.withOpacity(0.8),
                      backgroundBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ],
              ) 
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome Container
                WelcomeContainer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 10,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                // Schedule & Time Overview Container
                const Row(
                  children: [
                  // Schedule Overview Container
                  Expanded(
                  flex: 1,
                  child: ScheduleOverviewContainer(),
                  ),
                ]),

                //Second Row
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Daily Weather Overview Container
                      Expanded(
                        flex: 4,
                        child: DailyWeatherOverviewContainer(),
                      ),

                      // Teach Assist Overview Container
                      Expanded(
                        flex: 5,
                        child: TeachAssistOverviewContainer(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
