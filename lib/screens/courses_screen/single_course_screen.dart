import 'dart:collection';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:wolfpackapp/misc/page_navigator.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/screens/courses_screen/assignment.dart';

import '../../misc/menu_drawer.dart';

/*
########################
#=-=-= HomeScreen =-=-=#
########################
*/


class SingleCourseScreen extends StatefulWidget {
  final String courseCode;
  final String courseID;
  final dom.Document fetchedData;

  const SingleCourseScreen({
    super.key,
    required this.courseCode,
    required this.courseID,
    required this.fetchedData,
    });

  @override
  State<SingleCourseScreen> createState() => _SingleCourseScreenState();
}


class _SingleCourseScreenState extends State<SingleCourseScreen> {
  List<Assignment> courseData = [];
  List<Assignment> tempCourseData = [];
  double courseAverage = 0;
  // Stores [total earned mark, total marks, total weight]
  Map<String, List<dynamic>> categories = {};

  // Stores category information [Weighted Earned Percentage, Category Overall Weight]
  Map<String, List<double>> categoryTotal = {};

  // Stores categoryTotal AT EACH ASSIGNMENT []
  Map<String, List<List<double>>> categoryTrend = {};

  // Stores Assignment Overall Average (Not relative to course average)
  Map<String, double> assignmentAverages = {};

  bool showAssignments = true;
  bool showTrends = false;
  bool editCourses = false;
  int idGenerator = 0;

  @override
  void initState() {
    parseCourse(widget.fetchedData);
    super.initState();
  }

  Future<void> refreshPage() async {
    final newData = dom.Document.html(await fetchCourse(sharedPrefs.username, sharedPrefs.password, widget.courseID));
    parseCourse(newData);
  }

  void parseCourse(dom.Document data) {
    courseData = [];

    final rawData = data.querySelectorAll('body > div > div > div > div > table > tbody > tr')
        .map((element) => element.children)
        .toList();

    // Fetch all course categories (Knowledge, Thinking, Application etc.)
    categories = {for (var name in rawData[0].skip(1).map((category) => category.text.replaceAll(' ', ''))) name : [0,0]};
    categoryTrend = {for (var name in rawData[0].skip(1).map((category) => category.text.replaceAll(' ', ''))) name : []};

    // Fetch course average
    final courseAverageString = data.querySelector('body > div > div > div > table > tbody > tr > td > div')!.text;
    courseAverage = double.parse(courseAverageString.substring(0,courseAverageString.indexOf('%')));
    
    // Fetch all course category weights
    final rawWeightData = data.querySelectorAll('body > div > div > div > table > tbody > tr > td > table > tbody > tr')
        .map((element) => element.children)
        .toList();
    categoryTotal = {for (var category in rawWeightData.skip(1).map((category) => category)) category.first.text : [0,double.parse(category[category.length-2].text.substring(0,category[category.length-2].text.length-1))]};
    // Fetch marks from each assignment 
    for (final element in rawData) {
      if (element[0].attributes.containsKey('rowspan')) {
        // Fetch assignment title
        final title = element[0].text;

        List<List<double?>> categoryData = [];
        for (final category in element.skip(1)) {
          final tempData = category.text.trim().replaceAll('\t', '').split('\n');

          if (tempData.length > 1) {
            final score = (RegExp(r'[0-9]').hasMatch(tempData[0].substring(0, tempData[0].indexOf(' '))))
                ? double.parse(tempData[0].substring(0, tempData[0].indexOf(' ')))
                : 0.0;
            final total = double.parse(tempData[0].substring(tempData[0].indexOf('/ ')+2, tempData[0].indexOf(' =')));
            final weight = double.tryParse(tempData[1].substring(tempData[1].indexOf('=')+1));

            categoryData.add([score, total, weight ?? 0]);
          } else {
            categoryData.add([]);
          }
        }

        // Fetch assignment marks
        final marks = element.skip(1).map((category) => category.text.trim().replaceAll('\t', '').split('\n'));

        idGenerator++; // Creates Assignment ID
        courseData.add(
          Assignment(
            title: title,
            id: idGenerator,
            categories: LinkedHashMap.fromIterables(categories.keys,categoryData),
            )
        );
      }
    }

    tempCourseData = List.from(courseData);
    
    resetAverage();
  }
  
  resetAverage() {
    categories.updateAll((key, value) => [0,0]);
    categoryTrend.updateAll((key, value) => []);
    for (final assignment in tempCourseData) {
      double earnedPercentage = 0;
      double weightPercentage = 0;
      for (final category in assignment.categories.entries) {
        if (category.value.isNotEmpty) {
          earnedPercentage += category.value[0] / category.value[1] * ((category.value[2] > 0) ? category.value[2] : 1);
          weightPercentage += category.value[2];

          if (category.value[2] > 0) {
            categories[category.key]![0] += category.value[0] / category.value[1] * category.value[2];
            categories[category.key]![1] += category.value[2];
            
            setState(() {
              categoryTrend[category.key]!.add([
                (categoryTrend[category.key]!.isEmpty ? 0.0 : categoryTrend[category.key]!.last[0]) + category.value[0],
                (categoryTrend[category.key]!.isEmpty ? 0.0 : categoryTrend[category.key]!.last[1]) + category.value[1],
                (categoryTrend[category.key]!.isEmpty ? 0.0 : categoryTrend[category.key]!.last[2]) + category.value[2]
              ]);
            });
          }
        }
      }

      setState(() {
        assignmentAverages[assignment.title] = (weightPercentage > 0) ? earnedPercentage / weightPercentage : -1;
      });
    }

    double categoryEarnedPercentage = 0.0;
    double categoryWeightPercentage = 0.0;
    for (final category in categories.entries) {
      if (category.value.isNotEmpty && category.value[1] > 0) {
        categoryTotal[category.key]![0] = categories[category.key]![0] / categories[category.key]![1] * 100;
        categoryEarnedPercentage += categoryTotal[category.key]![0] * categoryTotal[category.key]![1];
        categoryWeightPercentage += categoryTotal[category.key]![1];
      }
    }

    setState(() {
      courseAverage = categoryEarnedPercentage / ((categoryWeightPercentage > 0) ? categoryWeightPercentage : 1); 
    });
  }

  removeAssignment(int id) {
    setState(() {
      tempCourseData.removeWhere((element) => element.id == id);
    });
    resetAverage();
    // categories.updateAll((key, value) => [0,0]);
    // for (final assignment in tempCourseData) {
    //   if (assignment.id != id) {
    //     for (final category in assignment.categories.entries) {
    //       if (category.value.isNotEmpty) {
    //         if (category.value[2] > 0) {
    //           categories[category.key]![0] += category.value[0];
    //           categories[category.key]![1] += category.value[1];
    //           categories[category.key]![2] += category.value[2];
    //         }
    //       }
    //     }
    //   }
    // }

    // double earnedPercentage = 0.0;
    // double weightPercentage = 0.0;
    // for (final category in categories.entries) {
    //   if (category.value.isNotEmpty && category.value[2] > 0) {
    //     earnedPercentage += category.value[0] / category.value[1] * category.value[2];
    //     weightPercentage += category.value[2];
    //   }
    // }

    // setState(() {
    //   courseAverage = (earnedPercentage / weightPercentage) * 100; 
    // });
  }

  addAssignment() {
    List<List<double?>> categoryData = [];
    for (int i = 0; i < categories.keys.length; i++) {
      categoryData.add([0,100,0]);
    }

    idGenerator++; // Creates Assignment ID
    setState(() {
      tempCourseData.insert(0,
        Assignment(
          title: 'Untitled Assignment',
          id: idGenerator,
          categories: LinkedHashMap.fromIterables(categories.keys,categoryData),
        )
      );
    });
    
    resetAverage();
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
          title: Text(widget.courseCode, style: GoogleFonts.roboto(fontSize: 20)),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          leading: const BackButton(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                splashRadius: 25,
                onPressed: () {
                  setState(() {
                    editCourses = !editCourses;
                  });
                },
                icon: !editCourses ? const Icon(Icons.edit) : Icon(Icons.edit_off, color: Theme.of(context).colorScheme.secondary,)
              ),
            ),
          ],
          centerTitle: true,
          shape: const Border(
            bottom: BorderSide(color: Colors.transparent),
          ),
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
        body: RefreshIndicator(
          onRefresh: () => refreshPage(),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            physics: const AlwaysScrollableScrollPhysics(),
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
                            percent: (courseAverage.isNaN) ? 0 : courseAverage / 100,
                            center: Text('${courseAverage.toStringAsFixed(1)}%',
                                style: GoogleFonts.roboto(
                                    fontSize: 25, fontWeight: FontWeight.w600)),
                            linearGradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.center,
                                colors: <Color>[
                                  Theme.of(context).colorScheme.secondary,
                                  Theme.of(context).colorScheme.secondary,
                                ]),
                            rotateLinearGradient: true,
                            animateFromLastPercent: true,
                            animation: true,
                            curve: Curves.easeInOut,
                            circularStrokeCap: CircularStrokeCap.round),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                CategoryTrends(categoryTrend: categoryTrend),
          
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                        style: GoogleFonts.roboto(
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      style: GoogleFonts.roboto(
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
          
                (editCourses && showAssignments) ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () {
                      addAssignment();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                          ),
                      
                          Text('Add An Assignment',
                            style: GoogleFonts.roboto(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20, fontWeight: FontWeight.w600)
                          ),
                        ],
                      ),
                    ),
                  ),
                ) : const SizedBox.shrink(),
          
          
                (showAssignments) ? Column(
                  children: <Widget>[
                    for (final assignment in tempCourseData)
                      AssignmentOverview(assignment: assignment, assignmentAverages: assignmentAverages, editingMode: editCourses, removeAssignment: removeAssignment, resetAverage: resetAverage,),
                  ],
                ) : const SizedBox.shrink(),
          
                (showTrends) ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 20),
                      padding: const EdgeInsets.all(10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categories.keys.length,
                      itemBuilder: (context, index) {
                        List<FlSpot> trends = [];
                        double trendMax = 0;
                        double trendMin = 100;
                
                        final category = categories.keys.elementAt(index);
                
                        for (final checkpoint in categoryTrend[category]!) {
                          if(checkpoint.isNotEmpty && checkpoint[2] > 0) {
                            final mark = double.parse((checkpoint[0] / checkpoint[1] * 100).toStringAsFixed(1));
                
                            trends.add(FlSpot(trends.length.floorToDouble(), mark));
                
                            if (mark > trendMax) trendMax = mark;
                            if (mark < trendMin) trendMin = mark;
                          }
                        }
                              
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
      ),
    );
  }
}

class CategoryTrends extends StatefulWidget {
  const CategoryTrends({
    super.key,
    required this.categoryTrend,
  });

  final Map<String, List<List<double>>> categoryTrend;

  @override
  State<CategoryTrends> createState() => _CategoryTrendsState();
}

class _CategoryTrendsState extends State<CategoryTrends> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: 120,
            width: widget.categoryTrend.length*50,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
                  tooltipMargin: 0,
                  tooltipPadding: EdgeInsets.zero,
                  getTooltipColor: (group) => Colors.transparent,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      (group.barRods[rodIndex].toY != 40.2665) ? '${(group.barRods[rodIndex].toY - 40.2665).toStringAsFixed(1)}%' : 'N/A', GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w600)
                    );
                  },
                )),
                maxY: 140.2665,
                minY: 0,
                backgroundColor: Colors.transparent,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(border: Border(bottom: BorderSide(width: 2,color: Theme.of(context).colorScheme.tertiary))),
                barGroups: widget.categoryTrend.entries.map((entry) {
                  int index = widget.categoryTrend.keys.toList().indexOf(entry.key);
                  List<double> value = (entry.value.isNotEmpty) ? entry.value.last : [0,0,-1];
          
                  return BarChartGroupData(
                    showingTooltipIndicators: [0],
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (value[2] > 0) ? double.parse((value[0] / value[1] * 100).toStringAsFixed(1))+40.2665 : 40.2665,
                        color: Theme.of(context).colorScheme.secondary,
                        width: 40,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
                  
                titlesData: FlTitlesData(
                  show: false,
                )
              ),
            ),
          ),
        ),

        // Text Only
        Center(
          child: SizedBox(
            height: 110,
            width: widget.categoryTrend.length*50,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: widget.categoryTrend.entries.map((entry) {
                  int index = widget.categoryTrend.keys.toList().indexOf(entry.key);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: 0,
                        color: Theme.of(context).colorScheme.secondary,
                        width: 40,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
                  
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          child: Text('${widget.categoryTrend.keys.toList()[value.floor()].split('/').map((l) => l[0]).join(' / ')}',
                          style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w600),), axisSide: meta.axisSide);
                      },
                    )
                    )
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AssignmentOverview extends StatefulWidget {
  AssignmentOverview({
    super.key,
    required this.assignment,
    required this.assignmentAverages,
    required this.editingMode,
    required this.removeAssignment,
    required this.resetAverage,
  });

  final Assignment assignment;
  final Map<String, double> assignmentAverages;
  final bool editingMode;
  final Function removeAssignment;
  final Function resetAverage;

  @override
  State<AssignmentOverview> createState() => _AssignmentOverviewState();
}

class _AssignmentOverviewState extends State<AssignmentOverview> {
  bool editingThis = false;
  bool isSelected = false;
  String markMode = 'percentage';
  String name = '';

  @override
  void initState() {
    super.initState();
    name = widget.assignment.title;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          if (!widget.editingMode) {
            setState(() {
              isSelected = !isSelected;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
            boxShadow: const [BoxShadow(blurRadius: 5)],
          ),
          padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: (widget.editingMode) ? 8 : 15),
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 5,
                      child: (!editingThis) ? Text(
                          widget.assignment.title,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800)
                      ) : TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Untitled Assignment',
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                              )
                          ),
                          initialValue: widget.assignment.title,
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w800),
                          onChanged: (value) {
                            setState(() {
                              widget.assignment.title = (value.isNotEmpty) ? value : 'Untitled Assignment';
                            });
                          },
                      ),
                    ),
              
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (!widget.editingMode) ? Container(
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
                              child: Text(widget.assignmentAverages[widget.assignment.title]! >= 0 ? '${(widget.assignmentAverages[widget.assignment.title]!*100).toStringAsFixed(1)}%' : 'Formative',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16, fontWeight: FontWeight.w800))
                            ),
                          ) :
                    
                          Row(
                            children: [
                              // Edit Button
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 20,
                                  onPressed: () {
                                    setState(() {
                                      editingThis = !editingThis;
                                    });
                                  },
                                  icon: const Icon(Icons.edit_note)
                                ),
                              ),
                          
                              // Delete Button
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 20,
                                  onPressed: () {
                                    setState(() {
                                      editingThis = false;
                                      widget.removeAssignment(widget.assignment.id);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.secondary)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              
                const Padding(padding: EdgeInsets.only(top: 6)),
            
                (!widget.editingMode) ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    percent: widget.assignmentAverages[widget.assignment.title]! >= 0 ? widget.assignmentAverages[widget.assignment.title]! : 0,
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
                ) : const SizedBox.shrink(),
                
                //#=-=-=-=-=-=-=-=-=-=-=#
                //#   Category Blocks   #
                //#=-=-=-=-=-=-=-=-=-=-=#
                (isSelected && !widget.editingMode) ? Column(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 10)),

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
                                '${category.key.split('/').map((l) => l[0]).join(' / ')} ${(category.value[2] > 0) ? '(Weight: ${category.value[2].toStringAsFixed(1)}' : '(No Weight'})',
                                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
              
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${category.value[0].toStringAsFixed(1)} / ${category.value[1].toStringAsFixed(1)} = ${(category.value[0] / category.value[1] * 100).toStringAsFixed(1)}%',
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
                ) : const SizedBox.shrink(),

                //#=-=-=-=-=-=-=-=-=-=-=-=-=-=#
                //#   Category Edit Sliders   #
                //#=-=-=-=-=-=-=-=-=-=-=-=-=-=#
                (editingThis && widget.editingMode) ? Column(
                  children: <Widget>[
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
                                category.key,
                                style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),

                            // Fraction Button
                            Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 20,
                                  onPressed: () {
                                    setState(() {
                                      markMode = 'fraction';
                                    });
                                  },
                                  icon: const Icon(Icons.tune,size: 15)
                                ),
                            ),
                          
                            // Percentage Button
                            Material(
                              color: Colors.transparent,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                splashRadius: 20,
                                onPressed: () {
                                  setState(() {
                                    markMode = 'percentage';
                                  });
                                },
                                icon: const Icon(Icons.percent,size: 15)
                              ),
                            ),
                          ],
                        ),

                        CategorySlider(
                          markMode: markMode,
                          resetAverage: widget.resetAverage,
                          category: category.key,
                          init: category.value,
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

class CategorySlider extends StatefulWidget {
  const CategorySlider({
    super.key,
    required this.markMode,
    required this.resetAverage,
    required this.category,
    required this.init,
  });

  final String markMode;
  final Function resetAverage;
  final String category;
  final List<dynamic> init;

  

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  List<dynamic> values = [];

  @override
  void initState() {
    super.initState();
    values = widget.init;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            children: (widget.markMode == 'fraction') ? <Widget>[
              IntrinsicWidth(
                child: TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '0.0',
                    contentPadding: EdgeInsets.zero,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                    )
                  ),
                  controller: TextEditingController(text: values[0].toStringAsFixed(1)),
                  
                  style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                  onFieldSubmitted: (value) {
                    double mark = double.tryParse(value) ?? values[0];
                    if (mark < 0) mark = 0;
                    if (mark > 100) mark = 100;
                    setState(() {
                      (mark > values[1]) ? values[0] = values[1] : values[0] = mark;
                    });
                  },
                ),
              ),

              Text(
                ' / ',
                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
              ),

              IntrinsicWidth(
                child: TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '0.0',
                    contentPadding: EdgeInsets.zero,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                    )
                  ),
                  controller: TextEditingController(text: values[1].toStringAsFixed(1)),
                  style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                  onFieldSubmitted: (value) {
                    double mark = double.tryParse(value) ?? values[1];
                    if (mark < 0) mark = 0;
                    if (mark > 100) mark = 100;
                    setState(() {
                      values[1] = mark;
                      if (values[0] > values[1]) {
                        values[0] = mark;
                      }
                    });
                  },
                ),
              ),

              Text(
                ' = ${(values[0] / values[1] * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ] : <Widget>[
              IntrinsicWidth(
                child: TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '0.0',
                    contentPadding: EdgeInsets.zero,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                    )
                  ),
                  controller: TextEditingController(text: (values[0] / values[1] * 100).toStringAsFixed(1)),
                  style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                  onFieldSubmitted: (value) {
                    double mark = double.tryParse(value) ?? (values[0] / values[1]) * 100;
                    if (mark < 0) mark = 0;
                    if (mark > 100) mark = 100;
                    setState(() {
                      values[0] = values[1] * (mark/100);
                    });
                  },
                ),
              ),

              Text(
                '%',
                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),  
        ),
        (widget.markMode == 'fraction') ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape:const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: values[0],
              max: values[1],
              onChanged: (value) {
                setState(() {
                  values[0] = value;
                  widget.resetAverage();
                });
              }
            ),
          ),
        ) : const SizedBox.shrink(),
        (widget.markMode == 'fraction') ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape:const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: values[1],
              max: 100,
              onChanged: (value) {
                setState(() {
                  values[1] = value;
                  if (values[0] > values[1]) {
                    values[0] = values[1];
                  }
                  widget.resetAverage();
                });
              }
            ),
          ),
        ) : const SizedBox.shrink(),

        (widget.markMode == 'percentage') ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape:const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: (values[0] / ((values[1] > 0) ? values[1] : 1)) * 100,
              max: 100,
              onChanged: (value) {
                setState(() {
                  if(values[1] == 0) values[1] = 100.0;
                  values[0] = values[1] * (value / 100);
                  widget.resetAverage();
                });
              }
            ),
          ),
        ) : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Text(
                (values[2] > 0) ? 'Weight: ' : '(No Weight): ',
                style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
              ),

              IntrinsicWidth(
                child: TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '0.0',
                    contentPadding: EdgeInsets.zero,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                    )
                  ),
                  controller: TextEditingController(text: values[2].toStringAsFixed(1)),
                  
                  style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                  onFieldSubmitted: (value) {
                    double weight = double.tryParse(value) ?? values[2];
                    if (weight < 0) weight = 0;
                    if (weight > 100) weight = 100;
                    setState(() {
                      values[2] = weight;
                    });
                  },
                ),
              ),

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SliderTheme(
            data: SliderThemeData(
              thumbColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor: Theme.of(context).colorScheme.secondary,
              inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape:const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: values[2],
              max: 100,
              onChanged: (value) {
                setState(() {
                  values[2] = value;
                  widget.resetAverage();
                });
              }
            ),
          ),
        ),
      ],
    );
  }
}

// class AssignmentConfiguration extends StatefulWidget {
//   final Assignment? assignment;
//   final Function addAssignment;
//   final Function editAssignment;
//   final bool isEditing;

//   const AssignmentConfiguration(
//     {super.key,
//     this.assignment,
//     required this.addAssignment,
//     required this.editAssignment,
//     required this.isEditing,
//   });

//   @override
//   State<AssignmentConfiguration> createState() => _AssignmentConfigurationState();
// }

// class _AssignmentConfigurationState extends State<AssignmentConfiguration> {

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
      
//       title: Text((widget.isEditing) ? 'Edit ${widget.assignment!.title}' : 'Add Assignment',
//         style: GoogleFonts.roboto(
//           fontSize: 16, fontWeight: FontWeight.w900,
//           color: Theme.of(context).colorScheme.secondary)
//         ),

//       content: (widget.assignment != null) ? Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           for (final category in widget.assignment!.categories.keys) 
//           Column(
//             children: [
//               Container(color: Colors.black),
//               Row(
//                 children: [
//                   Text(category,
//                   style: GoogleFonts.roboto(
//                     fontSize: 16, fontWeight: FontWeight.w900,
//                     color: Theme.of(context).colorScheme.primary)
//                   ),
//                 ],
//               )
//             ],
//           ),
            
//         ],
//       ) : 
//       Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
          
//         ]
//       ),
                          
//       actions: [
//         TextButton(
//           child: Text('CANCEL',
//               style: GoogleFonts.roboto(
//                   fontSize: 16, fontWeight: FontWeight.w900,
//                   color: Theme.of(context).colorScheme.secondary)
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),

//         TextButton(
//           child: Text('CONFIRM',
//               style: GoogleFonts.roboto(
//                   fontSize: 16, fontWeight: FontWeight.w900,
//                   color: Theme.of(context).colorScheme.secondary)
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           }
//         ),
//       ],
//     );
//   }
// }
