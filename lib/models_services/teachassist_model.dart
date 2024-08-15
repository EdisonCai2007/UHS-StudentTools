import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' as http;


const String LOGINURL = 'https://ta.yrdsb.ca/yrdsb/index.php';
const String COURSEURL = 'https://ta.yrdsb.ca/live/students/listReports.php?';

Future<List<String?>> authorizeUser(String username, String password) async {
  try {
    var res = await http.post(
      Uri.parse(LOGINURL),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'subject_id': '0',
        'username': username,
        'password': password,
        'submit': 'Login',
      }
    );

    // print(res.statusCode);
    // print(res.headers);
    // print(res.body);
    if (res.statusCode == 302) {
      var cookies = [res.headersSplitValues['set-cookie']?[5].substring(14,27),res.headersSplitValues['set-cookie']?[6].substring(11,17)];
      return cookies;
    } else {
      throw Exception('1 ~ Failed to Authorize User');
    }
  } catch (e) {
    throw Exception('2 ~ Invalid Login');
  }
}

Future<String> fetchMarks(username, password) async {
  var cookies = await authorizeUser(username, password);

  try {
    http.Response response = await http.get(
      Uri.parse('${COURSEURL}student_id=${cookies[1]}'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'session_token=${cookies[0]}; student_id=${cookies[1]}',
      },
    );

    log(response.body);
    if (response.statusCode == 200) {
      return "Bob";
    } else {
      throw Exception('Failed to load TeachAssist Marks');
    }
  } catch (e) {
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
