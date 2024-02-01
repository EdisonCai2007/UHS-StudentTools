import 'package:flutter/material.dart';
import 'package:wolfpackapp/themes/themes.dart';
import 'package:wolfpackapp/themes/theme_manager.dart';
import 'package:wolfpackapp/schedule_overview_container.dart';

// Home Screen Page; Holds The Many Crucial Widgets and Announcements
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
      ),

      bottomNavigationBar: BottomAppBar(
        shadowColor: Colors.black,
        child: Center(
          child: Text(
            "Nav Bar Placeholder Text",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),

      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScheduleOverviewContainer(),
            Container(
              decoration: BoxDecoration(
                color: Themes().darkAccent,
                borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
                boxShadow: const [
                  BoxShadow(blurRadius: 10)
                ],
              ),
              height: 600,
              margin: const EdgeInsets.all(60),
              padding: const EdgeInsets.all(50),
            ),
          ],
        ),
      ),
    );
  }
}