import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/screens/guidance_screen/appointment_overview_container.dart';
import 'package:wolfpackapp/screens/guidance_screen/appointment_picker_container.dart';

import '/menu_drawer.dart';

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
    return Scaffold(
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
                  children: [
                    Positioned(
                      top: -250,
                      right: -120,
                      child: Container(
                        height: 600,
                        width: 500,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                          //backgroundBlendMode: BlendMode.color,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.secondary,
                                blurRadius: 150,
                                blurStyle: BlurStyle.outer)
                          ],
                        ),
                      ),
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
          
    );
  }
}
