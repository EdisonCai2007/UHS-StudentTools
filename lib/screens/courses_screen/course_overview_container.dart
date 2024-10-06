import 'dart:collection';
import 'package:html/dom.dart' as dom;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/screens/courses_screen/single_course_screen.dart';


class CourseOverviewContainer extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseOverviewContainer({
    super.key,
    required this.course,
  });


  @override
  State<CourseOverviewContainer> createState() =>
      _CourseOverviewContainerState();
}

class _CourseOverviewContainerState extends State<CourseOverviewContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final id = widget.course['Subject ID'];

        if (id != null) {
          final fetchedData = dom.Document.html(await fetchCourse(sharedPrefs.username, sharedPrefs.password, id));

          // ignore: use_build_context_synchronously
          PageNavigator.changePage(context, SingleCourseScreen(courseCode: widget.course['Code'], fetchedData: fetchedData,));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
          boxShadow: const [BoxShadow(blurRadius: 5)],
        ),
        height: 160,
        margin: const EdgeInsets.only(
          top: 30,
          left: 30,
          right: 30,
        ),
        padding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
        child: Row(
          children: [

            /*
            #########################
            #=-=-= Course Info =-=-=#
            #########################
            */
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.course['Code']}:',
                      style: GoogleFonts.roboto(
                          fontSize: 12, fontWeight: FontWeight.w600)
                    ),
                    Text(widget.course['Name'] != '' ? widget.course['Name'] : widget.course['Code'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.w600)
                    ),

                    const SizedBox(height: 5),

                    Text('Period: ${widget.course['Period'].toString().substring(1,widget.course['Period'].toString().length-1)}',
                      style: GoogleFonts.roboto(
                          fontSize: 14, fontWeight: FontWeight.w400)
                    ),
                    Text('Rm. ${widget.course['Room']}',
                      style: GoogleFonts.roboto(
                          fontSize: 13, fontWeight: FontWeight.w400)
                    ),
                  ],
                ),
              ),
            ),

            /*
            ############################
            #=-=-= Course Average =-=-=#
            ############################
            */
            Expanded(
              flex: 3,
              child: widget.course['Course Average'] != null ? Stack(
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
                    height: 96,
                    width: 96,
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
                        radius: 60,
                        lineWidth: 12,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        percent: double.parse(widget.course['Course Average']) / 100,
                        center: Text('${double.parse(widget.course['Course Average']).toStringAsFixed(1)}%',
                            style: GoogleFonts.lato(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                        linearGradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.center,
                            colors: <Color>[
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.secondary,
                            ]),
                        animation: true,
                        curve: Curves.easeInOut,
                        rotateLinearGradient: true,
                        circularStrokeCap: CircularStrokeCap.round),
                  ),
                ],
              ) :
              Text('Please see teacher for current status regarding achievement in this course',
                  textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w400)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
