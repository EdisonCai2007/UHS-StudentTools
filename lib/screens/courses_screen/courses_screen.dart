import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wolfpackapp/screens/courses_screen/course_overview_container.dart';

import '../../models_services/teachassist_model.dart';
import '/menu_drawer.dart';

/*
########################
#=-=-= HomeScreen =-=-=#
########################
*/

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  double average = 0;

  @override
  void initState() {
    super.initState();

    int numCourses = 0;
    for (final course in TeachAssistModel.courses) {
      if (course['Semester'] == 1) {
        average += double.parse(course['Course Average'] ?? '0');
        numCourses++;
      }
    }

    average /= numCourses;
  }

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
        title: Text('Courses', style: GoogleFonts.lato(fontSize: 20)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:40),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      height: 160,
                      width: 160,
                    ),

                    Container(
                      foregroundDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      child: CircularPercentIndicator(
                          radius: 100,
                          lineWidth: 20,
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          percent: average / 160,
                          center: Text('$average%',
                              style: GoogleFonts.lato(
                                  fontSize: 30, fontWeight: FontWeight.w800)),
                          linearGradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.center,
                              colors: <Color>[
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.secondary,
                              ]),
                          rotateLinearGradient: true,
                          circularStrokeCap: CircularStrokeCap.round),
                    ),
                  ],
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(TeachAssistModel.courses.length, (index) =>
                  CourseOverviewContainer(course: TeachAssistModel.courses[index])
              ),
            )
          ],
        ),
      ),
    );
  }
}
