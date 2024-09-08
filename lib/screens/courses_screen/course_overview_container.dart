import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        boxShadow: const [BoxShadow(blurRadius: 5)],
      ),
      height: 200,
      margin: const EdgeInsets.only(
        top: 30,
        left: 30,
        right: 30,
      ),
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.course['Code']}:\n${widget.course['Name']}',
            style: GoogleFonts.roboto(
                fontSize: 20, fontWeight: FontWeight.w600)
          ),

        ],
      ),
    );
  }
}
