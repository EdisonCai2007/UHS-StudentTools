import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/screens/courses_screen/assignment.dart';


class AssignmentOverviewContainer extends StatefulWidget {
  final Assignment assignment;

  const AssignmentOverviewContainer({
    super.key,
    required this.assignment,
  });


  @override
  State<AssignmentOverviewContainer> createState() =>
      _AssignmentOverviewContainerState();
}

class _AssignmentOverviewContainerState extends State<AssignmentOverviewContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.assignment.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
                      boxShadow: const [BoxShadow(blurRadius: 5)],
                    ),
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 5,
                      right: 5,
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 3,
                          widget.assignment.title,
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800)
                        ),

                        const Padding(padding: EdgeInsets.only(top: 15)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
    );
  }
}

