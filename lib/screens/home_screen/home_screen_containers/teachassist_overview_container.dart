import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/screens/courses_screen/courses_screen.dart';

import '../../../page_navigator.dart';
import '../../no_account_dialog.dart';

class TeachAssistOverviewContainer extends StatefulWidget {
  const TeachAssistOverviewContainer({super.key});

  @override
  State<TeachAssistOverviewContainer> createState() =>
      _TeachAssistOverviewContainerState();
}

class _TeachAssistOverviewContainerState
    extends State<TeachAssistOverviewContainer> {
  double average = 0;

  @override
  void initState() {
    super.initState();

    int numCourses = 0;
    for (final course in TeachAssistModel.courses) {
      if (course['Semester'] == 1) {
        average += double.parse(course['Course Average']);
        numCourses++;
      }
    }

    average /= numCourses;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PageNavigator.changePage(context, const CoursesScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
          boxShadow: const [BoxShadow(blurRadius: 5)],
        ),
        height: 300,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(top: 30),
        child: (TeachAssistModel.courses.isEmpty) ? NoAccountDialog() : Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Container(
                    foregroundDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    child: CircularPercentIndicator(
                        radius: 50,
                        lineWidth: 10,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        percent: average / 100,
                        center: Text('$average%',
                            style: GoogleFonts.roboto(
                                fontSize: 18, fontWeight: FontWeight.w800)),
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
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        TeachAssistModel.courses.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            child: LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              lineHeight: 20,
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              percent: double.parse(TeachAssistModel.courses[index]['Course Average']) / 100,
                              center: Text(
                                  TeachAssistModel.courses[index]['Code'],
                                  style: GoogleFonts.roboto(
                                      fontSize: 10, fontWeight: FontWeight.w800)),
                              linearGradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                                colors: <Color>[
                                  Theme.of(context).colorScheme.secondary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              barRadius: const Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future getMarks() async {
  //   var rawData = await fetchMarks(sharedPrefs.username, sharedPrefs.password);
  //
  //   // log(rawData.body!.innerHtml);
  //   final courseNames = rawData
  //       .querySelectorAll('body > div > div > div > table > tbody > tr > td')
  //       .map((element) => element.text.trim().replaceAll(RegExp('[\t\n]'), ''))
  //       .toList();
  //   // for (final course in courseNames) {
  //   //   print(course);
  //   // }
  //
  //   setState(() {
  //     courses = List.generate(
  //       ((courseNames.length - 1) / 3).floor(),
  //       (index) => TeachAssistCourse(
  //         heading: courseNames[index * 3]
  //             .substring(0, courseNames[index * 3].indexOf('Block:')),
  //         subheading: courseNames[index * 3]
  //             .substring(courseNames[index * 3].indexOf('Block:') + 7),
  //         courseAverage: courseNames[index * 3 + 2],
  //       ),
  //     );
  //   });
  // }
}
