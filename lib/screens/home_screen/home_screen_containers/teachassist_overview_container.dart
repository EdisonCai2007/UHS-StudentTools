import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/shared_prefs.dart';

class TeachAssistOverviewContainer extends StatefulWidget {
  const TeachAssistOverviewContainer({super.key});

  @override
  State<TeachAssistOverviewContainer> createState() =>
      _TeachAssistOverviewContainerState();
}

class _TeachAssistOverviewContainerState
    extends State<TeachAssistOverviewContainer> {
  List<TeachAssistCourse> courses = [];

  @override
  void initState() {
    super.initState();

    getMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        boxShadow: const [BoxShadow(blurRadius: 10)],
      ),
      height: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
                strokeWidth: 15,
                value: 0.5,
              ),
            ),
          ),
          SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                        courses.length,
                        (index) => Column(
                                children: [
                                  Text(courses[index].heading),
                                  Text(courses[index].subheading),
                                  Text(courses[index].courseAverage),
                                ],
                            )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getMarks() async {
    var rawData = await fetchMarks(sharedPrefs.username, sharedPrefs.password);

    // log(rawData.body!.innerHtml);
    final courseNames = rawData
        .querySelectorAll('body > div > div > div > table > tbody > tr > td')
        .map((element) => element.text.trim().replaceAll(RegExp('[\t\n]'), ''))
        .toList();
    // for (final course in courseNames) {
    //   print(course);
    // }

    setState(() {
      courses = List.generate(
        ((courseNames.length - 1) / 3).floor(),
        (index) => TeachAssistCourse(
          heading: courseNames[index * 3]
              .substring(0, courseNames[index * 3].indexOf('Block:')),
          subheading: courseNames[index * 3]
              .substring(courseNames[index * 3].indexOf('Block:') + 7),
          courseAverage: courseNames[index * 3 + 2],
        ),
      );
    });
  }
}
