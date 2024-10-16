import 'dart:collection';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/screens/courses_screen/assignment.dart';

import '../../misc/menu_drawer.dart';

/*
########################
#=-=-= HomeScreen =-=-=#
########################
*/

class SingleCourseScreen extends StatefulWidget {
  final String courseCode;
  final dom.Document fetchedData;

  const SingleCourseScreen({
    super.key,
    required this.courseCode,
    required this.fetchedData,
    });

  @override
  State<SingleCourseScreen> createState() => _SingleCourseScreenState();
}

class _SingleCourseScreenState extends State<SingleCourseScreen> {
  List<Assignment> courseData = [];
  double courseAverage = 0;
  List<String> categories = [];
  Map<String, double> assignmentAverages = {};

  bool showAssignments = true;
  bool showTrends = false;

  @override
  void initState() {
    parseCourse();
    super.initState();
  }

  void parseCourse() {
    final rawData = widget.fetchedData.querySelectorAll('body > div > div > div > div > table > tbody > tr')
        .map((element) => element.children)
        .toList();

    final courseAverageString = widget.fetchedData.querySelector('body > div > div > div > table > tbody > tr > td > div')!.text;
    courseAverage = double.parse(courseAverageString.substring(0,courseAverageString.indexOf('%')));
    
    // Fetch all course categories (Knowledge, Thinking, Application etc.)
    categories = rawData[0].skip(1).map((category) => category.text).toList();

    // Fetch marks from each assignment 
    for (final element in rawData) {
      if (element[0].attributes.containsKey('rowspan')) {
        // Fetch assignment title
        final title = element[0].text;

        List<List<double?>> categoryData = [];
        for (final category in element.skip(1)) {
          final tempData = category.text.trim().replaceAll('\t', '').split('\n');

          if (tempData.length > 1) {
            final score = double.parse(tempData[0].substring(0,tempData[0].indexOf(' ')));
            final total = double.parse(tempData[0].substring(tempData[0].indexOf('/ ')+2, tempData[0].indexOf(' =')));
            final weight = double.tryParse(tempData[1].substring(tempData[1].indexOf('=')+1));

            categoryData.add([score, total, weight ?? -1]);
          } else {
            categoryData.add([]);
          }
        }

        // Fetch assignment marks
        final marks = element.skip(1).map((category) => category.text.trim().replaceAll('\t', '').split('\n'));

        courseData.add(
          Assignment(
            title: title,
            categories: LinkedHashMap.fromIterables(categories,categoryData),
            )
        );
      }
    }

    for (final assignment in courseData) {
      double earnedPercentage = 0;
      double weightPercentage = 0;
      for (final category in assignment.categories.entries) {
        if (category.value.isNotEmpty) {
          weightPercentage += category.value[2];
          earnedPercentage += category.value[0] / category.value[1] * category.value[2];
        }
      }

      assignmentAverages[assignment.title] = earnedPercentage / weightPercentage;

      print(assignmentAverages[assignment.title]);
    }
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
          title: Text(widget.courseCode, style: GoogleFonts.lato(fontSize: 20)),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          leading: const BackButton(),
          centerTitle: true,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
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
                      height: 120,
                      width: 120,
                    ),

                    Container(
                      height: 180,
                      foregroundDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      child: CircularPercentIndicator(
                          radius: 70,
                          lineWidth: 10,
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          percent: courseAverage / 100,
                          center: Text('${courseAverage.toStringAsFixed(1)}%',
                              style: GoogleFonts.lato(
                                  fontSize: 25, fontWeight: FontWeight.w800)),
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

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style,
                              onPressed: (showAssignments == true) ? null : () {
                                setState(() {
                                  showAssignments = true;
                                  showTrends = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text('Assignments',
                                      style: GoogleFonts.lato(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 20, fontWeight: FontWeight.w600)),
                                ),
                              )
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            style: Theme.of(context).elevatedButtonTheme.style,
                            onPressed: (showTrends == true) ? null : () {
                              setState(() {
                                showTrends = true;
                                showAssignments = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text('Trends',
                                    style: GoogleFonts.lato(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 20, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              (showAssignments) ? Column(
                children: <Widget>[
                  for (final assignment in courseData)
                    AssignmentOverview(assignment: assignment, assignmentAverages: assignmentAverages),
                ],
              ) : const SizedBox.shrink(),

              (showTrends) ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 20),
                    padding: const EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      List<FlSpot> trends = [];
                      double trendMax = 0;
                      double trendMin = 100;
              
                      final category = categories[index];
              
                      for (final assignment in courseData) {
                        if(assignment.categories[category]!.isNotEmpty && assignment.categories[category]![2] > 0) {
                          final mark = double.parse((assignment.categories[category]![0] / assignment.categories[category]![1] * 100).toStringAsFixed(1));
              
                          trends.add(FlSpot(trends.length.floorToDouble(), mark));
              
                          if (mark > trendMax) trendMax = mark;
                          if (mark < trendMin) trendMin = mark;
                        }
                      }
              
                      print(trends.isNotEmpty);
              
                      return (trends.isNotEmpty) ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
              
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: AspectRatio(
                                aspectRatio: 1.2,
                                child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(
                                          drawVerticalLine: false,
                                          horizontalInterval: ((trendMax - trendMin) / 5).ceilToDouble() + 1,
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)
                                        ),
                                        bottomTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)
                                        ),
                                        rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            maxIncluded: false,
                                            minIncluded: false,
                                            interval: ((trendMax - trendMin) / 5).ceilToDouble() + 1,
                                            reservedSize: 25,
                                            getTitlesWidget: (value, meta) => Text('${value.ceil()}%',
                                              style: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                          isCurved: true,
                                          preventCurveOverShooting: true,
                                          spots: trends,
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                      ],
                                      lineTouchData: const LineTouchData(
                                          touchTooltipData: LineTouchTooltipData(
                                            tooltipRoundedRadius: 20,
                                          )
                                      ),
                                      maxY: min(100.5, trendMax+3.09),
                                      minY: max(-0.5, trendMin-3.09),
                                      maxX: (trends.length > 1) ? trends.length-1 : trends.length-0,
                                      minX: (trends.length > 1) ? 0 : -1,
              
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ) : null;
                    }
                ),
              ) : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentOverview extends StatefulWidget {
  const AssignmentOverview({
    super.key,
    required this.assignment,
    required this.assignmentAverages,
  });

  final Assignment assignment;
  final Map<String, double> assignmentAverages;

  @override
  State<AssignmentOverview> createState() => _AssignmentOverviewState();
}

class _AssignmentOverviewState extends State<AssignmentOverview> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
            boxShadow: const [BoxShadow(blurRadius: 5)],
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                          widget.assignment.title,
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800)
                      ),
                    ),
              
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius:
                                    const BorderRadius.all(Radius.elliptical(5, 5)),
                              ),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text('${(widget.assignmentAverages[widget.assignment.title]!*100).toStringAsFixed(1)}%',
                                    style: GoogleFonts.roboto(
                                        fontSize: 16, fontWeight: FontWeight.w800)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              
                const Padding(padding: EdgeInsets.only(top: 6)),
            
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    percent: widget.assignmentAverages[widget.assignment.title]!,
                    linearGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: <Color>[
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    animation: true,
                    curve: Curves.easeInOut,
                    barRadius: const Radius.circular(15),
                  ),
                ),


            
                (isSelected) ? Column(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 20)),

                    for (final category in widget.assignment.categories.entries)
                    (category.value.length <= 1) ? const SizedBox.shrink() :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
              
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${category.key.split(' ').map((l) => l[0]).join()} ${(category.value[2] > 0) ? '(Weight: ${category.value[2]}' : '(No Weight'})',
                                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
              
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${category.value[0]} / ${category.value[1]} = ${(category.value[0] / category.value[1] * 100).toStringAsFixed(1)}%',
                                  style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
              
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            lineHeight: 8,
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            percent: category.value[0] / category.value[1],
                            linearGradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: <Color>[
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            animation: true,
                            curve: Curves.easeInOut,
                            barRadius: const Radius.circular(15),
                          ),
                        ),
                      ],
                    ),
                  ]
                ) : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
