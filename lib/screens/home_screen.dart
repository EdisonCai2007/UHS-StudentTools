import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolfpackapp/containers/welcome_container.dart';
import 'package:wolfpackapp/containers/daily_weather_overview_container.dart';
import 'package:wolfpackapp/containers/schedule_overview_container.dart';
import 'package:wolfpackapp/containers/teachassist_overview_container.dart';
import 'package:wolfpackapp/menu_drawer.dart';
import 'package:wolfpackapp/themes/theme_manager.dart';
import 'package:google_fonts/google_fonts.dart';


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
      /*
      ####################
      #=-=-= AppBar =-=-=#
      ####################
      */
      appBar: AppBar(
        title: Text('Home',style: GoogleFonts.lato(fontSize: 25)),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => {
                    Provider.of<ThemeManager>(context, listen: false)
                        .toggleThemeMode(),
                  },
              icon: const Icon(Icons.dark_mode))
        ],
      ),

      /*
      ###################################
      #=-=-= Bottom Navigation Bar =-=-=#
      ###################################
      */
      bottomNavigationBar: BottomAppBar(
        shadowColor: Colors.black,
        child: Center(
          child: Text(
            'Nav Bar Placeholder Text',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),

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
        controller: ScrollController(),
        child: Column(
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
            ScheduleOverviewContainer(),

            //Second Row
            Padding(
              padding: const EdgeInsets.all(20),
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
      ),
    );
  }
}
