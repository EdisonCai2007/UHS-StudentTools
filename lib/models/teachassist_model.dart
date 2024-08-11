import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


const String LOGINURL = 'https://ta.yrdsb.ca/yrdsb/';
const String COURSEURL = 'https://ta.yrdsb.ca/live/students/listReports.php?';
//'Cookie': 'session_token=94TSQCA3DpD5s; student_id=194871'

Future<TeachAssistMarks> fetchMarks() async {

  try {
    var response = await http.post(
        Uri.parse(LOGINURL),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'subject_id': '0',
          'username': '341042810',
          'password': 'b72wxq8d',
          'submit': 'Login',
        }
    );

    print(response.body);
    print(response.statusCode);
    print(response.headers);
    if (response.statusCode == 200) {
      return TeachAssistMarks.fromJSON(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load TeachAssist Marks');
    }
  } catch (e, stackTrace) {
    print('Request failed with error: $e');
    print('Stack trace: $stackTrace');
    throw Exception('Failed to load TeachAssist Marks');
  }
}

class TeachAssistMarks {
  final String startTime;
  final String endTime;
  final String code;
  final String name;
  final String block;
  final String room;
  final String overallMark;
  final List assignments;
  final List weightTable;

  const TeachAssistMarks({
    required this.startTime,
    required this.endTime,
    required this.code,
    required this.name,
    required this.block,
    required this.room,
    required this.overallMark,
    required this.assignments,
    required this.weightTable,
  });

  factory TeachAssistMarks.fromJSON(Map<String, dynamic> json) {
    return switch (json) {
      {
        'start_time': String startTime,
        'end_time': String endTime,
        'code': String code,
        'name': String name,
        'block': String block,
        'room': String room,
        'overall_mark': String overallMark,
        'assignments': List assignments,
        'weight_table': List weightTable,
      } =>
        TeachAssistMarks(
          startTime: startTime,
          endTime: endTime,
          code: code,
          name: name,
          block: block,
          room: room,
          overallMark: overallMark,
          assignments: assignments,
          weightTable: weightTable,
        ),
      _ => throw const FormatException('Failed to load TeachAssist Marks')
    };
  }
}

/*
"start_time": "2019-09-03",
"end_time": "2020-01-31",
"code": "AVI2O1-01",
"name": "Visual Arts",
"block": "1",
"room": "319",
"overall_mark": 87.5664467885056,
"assignments": [],
"weight_table": {}
*/
