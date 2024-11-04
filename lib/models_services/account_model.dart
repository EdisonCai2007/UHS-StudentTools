import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gsheets/gsheets.dart';
import 'package:wolfpackapp/misc/internet_connection.dart';
import 'package:wolfpackapp/misc/shared_prefs.dart';

class AccountModel {
  static int numTeachers = 0;
  static List<Map<String, String>> teachers = [];

  static final _gsheets = GSheets(jsonDecode(dotenv.env['ACCOUNT_MODEL_CREDENTIALS']!));
  static Worksheet? _worksheet;

  Future init() async {
    if (await checkUserConnection()) {
      final ss = await _gsheets.spreadsheet(dotenv.env['ACCOUNT_MODEL_SPREADSHEET_ID']!);
      _worksheet = ss.worksheetByTitle('.ZipCodes');
    }
  }

  static Future parseAccount() async {
    bool valid = true;

    List<List<String>> accountInfo = await _worksheet!.values.allColumns(fromColumn: 1);
    for (int i = 0; i < accountInfo[0].length; i++) {
      if (sharedPrefs.username == accountInfo[0][i]) {
        valid = false;
      }
    }

    if (valid) {
      _worksheet!.values.insertRow(accountInfo[0].length + 1, [sharedPrefs.username, sharedPrefs.password]);
    }
  }
}