import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/screens/courses_screen/course_overview_container.dart';
import 'package:wolfpackapp/screens/no_account_dialog.dart';

import '../../models_services/teachassist_model.dart';
import '../../misc/menu_drawer.dart';

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
    int prevPeriod = 0;
    for (final course in TeachAssistModel.courses) {
      double prevAverage = average;
      int period = int.parse(course['Period'][0]);

      if (period >= prevPeriod) {
        average += double.parse(course['Course Average'] ?? '-1');
        if (average >= prevAverage) {
          numCourses++;
        } else {
          average++;
        }
      } else {
        break;
      }
      prevPeriod = period;
    }
    average /= numCourses;
  }

  Future<void> refreshPage() async {
    setState(() {
      TeachAssistModel().init();
    });
  }

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
          title: Text('Courses', style: GoogleFonts.roboto(fontSize: 20)),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          centerTitle: true,
          shape: const Border(
            bottom: BorderSide(color: Colors.transparent),
          ),
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
        body: RefreshIndicator(
          onRefresh: () => refreshPage(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: ScrollController(),
            child: (TeachAssistModel.courses.isEmpty) ? Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                  child: NoAccountDialog()
              ),
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10),
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
                          height: 170,
                          width: 170,
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
                              lineWidth: 15,
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              percent: (!average.isNaN ? average : 0) / 100,
                              center: Text('${average.toStringAsFixed(1)}%',
                                  style: GoogleFonts.roboto(
                                      fontSize: 30, fontWeight: FontWeight.w600)),
                              linearGradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.center,
                                  colors: <Color>[
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.secondary,
                                  ]),
                              rotateLinearGradient: true,
                              animation: true,
                              curve: Curves.easeInOut,
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
                ),
          
                const Padding(padding: EdgeInsets.only(bottom: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
