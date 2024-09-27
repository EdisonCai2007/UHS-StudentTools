import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/screens/courses_screen/assignment.dart';
import 'package:wolfpackapp/screens/no_account_dialog.dart';

import '../../models_services/teachassist_model.dart';
import '/menu_drawer.dart';

/*
########################
#=-=-= HomeScreen =-=-=#
########################
*/

class SingleCourseScreen extends StatefulWidget {
  final String subjectId;
  final String courseCode;

  const SingleCourseScreen({
    super.key,
    required this.subjectId,
    required this.courseCode,
    });

  @override
  State<SingleCourseScreen> createState() => _SingleCourseScreenState();
}

class _SingleCourseScreenState extends State<SingleCourseScreen> {
  dom.Document fetchedData = dom.Document();
  static List<Assignment> courseData = [];


  @override
  void initState() {
    _fetchCourse();
    super.initState();
  }

  Future<void> _fetchCourse() async {
    fetchedData = await fetchCourse(sharedPrefs.username, sharedPrefs.password, widget.subjectId);
    parseCourse();
  }

  void parseCourse() {
    final rawData = fetchedData.querySelectorAll('body > div > div > div > div > table > tbody > tr')
        .map((element) => element.children)
        .toList();
    
    // Fetch all course categories (Knowledge, Thinking, Application etc.)
    final categories = rawData[0].skip(1).map((category) => category.text).toList();

    // Fetch marks from each category per assignment 
    for (final element in rawData) {
      if (element[0].attributes.containsKey('rowspan')) {
        // Fetch assignment title
        final title = element[0].text;

        // Fetch assignment marks
        final marks = element.skip(1).map((category) => category.text.trim().replaceAll('\t', '').split('\n'));

        courseData.add(
          Assignment(
            title: title,
            categories: LinkedHashMap.fromIterables(categories,marks),
            )
        );
      }
    }
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
        title: Text(widget.courseCode, style: GoogleFonts.lato(fontSize: 20)),
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
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: NoAccountDialog()
          ),
        ),
      ),
    );
  }
}
