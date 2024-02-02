import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolfpackapp/containers/daily_weather_overview_container.dart';
import 'package:wolfpackapp/containers/schedule_overview_container.dart';
import 'package:wolfpackapp/containers/teachassist_overview_container.dart';
import 'package:wolfpackapp/menu_drawer.dart';
import 'package:wolfpackapp/themes/theme_manager.dart';

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
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => {
                    Provider.of<ThemeManager>(context, listen: false)
                        .toggleThemeMode(),
                  },
              icon: const Icon(Icons.dark_mode))
        ],
        foregroundColor: Theme.of(context).colorScheme.onSurface,
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
                    flex: 2,
                    child: DailyWeatherOverviewContainer(),
                  ),

                  // Teach Assist Overview Container
                  Expanded(
                    flex: 3,
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
