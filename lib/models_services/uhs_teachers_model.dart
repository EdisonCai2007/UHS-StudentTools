import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gsheets/gsheets.dart';
import 'package:wolfpackapp/misc/internet_connection.dart';

class UHSTeachersModel {
  static int numTeachers = 0;
  static List<Map<String,String>> teachers = [];

  static final _gsheets = GSheets(jsonDecode(dotenv.env['UHS_TEACHERS_CREDENTIALS']!));
  static Worksheet? _worksheet;
  
  Future init() async {
    if (await checkUserConnection()) {
      final ss = await _gsheets.spreadsheet(dotenv.env['UHS_TEACHERS_SPREADSHEET_ID']!);
      _worksheet = ss.worksheetByTitle('Teachers');
      loadTeachers();
    }
  }

  static Future loadTeachers() async {
    if (_worksheet == null) return;

    List<List<String>> teacherInfo = await _worksheet!.values.allColumns(fromColumn: 1);

    for (int i = 0; i < teacherInfo[0].length; i++) {
      teachers.add(<String, String>{});
      teachers[i]["First Name"] = teacherInfo[0][i];
      teachers[i]["Last Name"] = teacherInfo[1][i];
      teachers[i]["Departments"] = teacherInfo[2][i];
      teachers[i]["Email"] = teacherInfo[3][i];
      numTeachers++;
    }
  }
}