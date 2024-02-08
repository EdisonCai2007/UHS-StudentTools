import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<TeachAssistMarks> fetchMarks() async {
  final response = await http.get(
    Uri.https(
      'api.pegasis.site',
      '/yrdsb_ta/getmark_v2',
        jsonEncode({'number': '123456789', 'password': 'adksfb93'}) as Map<String, dynamic>?,
    ),
  );

  if (response.statusCode == 200) {
    return TeachAssistMarks.fromJSON(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    print(response.statusCode);
    throw Exception('Failed to load TeachAssist Marks');
  }
}

class TeachAssistMarks {
  final String start_time;
  final String end_time;
  final String code;
  final String name;
  final String block;
  final String room;
  final String overall_mark;
  final List assignments;
  final List weight_table;

  const TeachAssistMarks({
    required this.start_time,
    required this.end_time,
    required this.code,
    required this.name,
    required this.block,
    required this.room,
    required this.overall_mark,
    required this.assignments,
    required this.weight_table,
  });

  factory TeachAssistMarks.fromJSON(Map<String, dynamic> json) {
    return switch (json) {
      {
        'start_time': String start_time,
        'end_time': String end_time,
        'code': String code,
        'name': String name,
        'block': String block,
        'room': String room,
        'overall_mark': String overall_mark,
        'assignments': List assignments,
        'weight_table': List weight_table,
      } =>
        TeachAssistMarks(
          start_time: start_time,
          end_time: end_time,
          code: code,
          name: name,
          block: block,
          room: room,
          overall_mark: overall_mark,
          assignments: assignments,
          weight_table: weight_table,
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
