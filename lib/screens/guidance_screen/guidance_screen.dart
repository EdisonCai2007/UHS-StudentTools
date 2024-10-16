import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/screens/guidance_screen/appointment_overview_container.dart';
import 'package:wolfpackapp/screens/guidance_screen/appointment_picker_container.dart';

import '../../misc/menu_drawer.dart';

/*
########################
#=-=-= HomeScreen =-=-=#
########################
*/

class GuidanceScreen extends StatefulWidget {
  const GuidanceScreen({super.key});

  @override
  State<GuidanceScreen> createState() => _GuidanceScreenState();
}

class _GuidanceScreenState extends State<GuidanceScreen> {
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
          title: Text('Guidance', style: GoogleFonts.lato(fontSize: 20)),
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

                  // Appointment Overview Container
                  const AppointmentOverviewContainer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      height: 10,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  const AppointmentPickerContainer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
