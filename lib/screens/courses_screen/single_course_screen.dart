import 'dart:collection';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wolfpackapp/screens/courses_screen/assignment.dart';

import '/menu_drawer.dart';

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

    setState(() {
    });
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
                      center: Text('$courseAverage%',
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
          
            Column(
              children: <Widget>[
                for (final assignment in courseData)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
                        boxShadow: const [BoxShadow(blurRadius: 5)],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.title,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800)
                          ),
          
                          const Padding(padding: EdgeInsets.only(top: 15)),
          
                          Column(
                            children: <Widget>[
                              for (final category in assignment.categories.entries)
                              (category.value.length <= 1) ? const SizedBox(height: 0,) :
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
          
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          category.value[0],
                                          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ),
          
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            category.value[1],
                                            style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
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
                                      percent: double.parse(
                                        category.value[0].substring(
                                            category.value[0].indexOf('=')+ 2,
                                            category.value[0].indexOf('%')
                                          )) / 100,
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
                              )
                            ]
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
              List<FlSpot> trends = [];
              double trendMax = 0;
              double trendMin = 100;

              final category = categories[index];

              for (final assignment in courseData) {
                if(assignment.categories[category]![0].isNotEmpty) {
                  final mark = double.parse(assignment.categories[category]![0]
                  .substring(
                    assignment.categories[category]![0].indexOf('=')+ 2,
                    assignment.categories[category]![0].indexOf('%')
                  ));

                  trends.add(FlSpot(trends.length.floorToDouble(), mark));

                  if (mark > trendMax) trendMax = mark;
                  if (mark < trendMin) trendMin = mark;
                }
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(
                            drawVerticalLine: false
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
                          maxY: min(100.5, trendMax+3),
                          minY: max(-0.5, trendMin-3),
                          maxX: (trends.length > 1) ? trends.length-1 : trends.length-0,
                          minX: (trends.length > 1) ? 0 : -1,
                          
                        )
                      ),
                    ),
                  ),
                ],
              );
              }
            ),
          ],
        ),
      ),
    );
  }
}
