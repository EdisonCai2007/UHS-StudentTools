import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:wolfpackapp/misc/internet_connection.dart';
import 'package:wolfpackapp/models_services/club_announcement.dart';

class ClubAnnouncementsModel {
  static int numTeachers = 0;
  static List<ClubAnnouncement> announcements = [];

  static Map<String,String> clubColours = {};

  static final _gsheets = GSheets(jsonDecode(dotenv.env['CLUB_ANNOUNCEMENTS_CREDENTIALS']!));
  static Worksheet? _worksheet;
  
  Future init() async {
    if (await checkUserConnection()) {
      final ss = await _gsheets.spreadsheet(dotenv.env['CLUB_ANNOUNCEMENTS_SPREADSHEET_ID']!);
      _worksheet = ss.worksheetByTitle('UHS');
      await loadAnnouncements();
    }
  }

  static Future loadAnnouncements() async {
    if (_worksheet == null) return;

    List<List<String>> clubInfo = await _worksheet!.values.allRows(fromColumn: 9, fill: true);
    List<List<String>> announcementInfo = await _worksheet!.values.allColumns(fromColumn: 1, fromRow: 4, fill: true);

    for (int i = 0; i < clubInfo[0].length; i++) {
      if (clubInfo[0][i] != '') {
        clubColours[clubInfo[0][i]] = clubInfo[1][i];
      } else {
        break;
      }
    }

    for (int i = 0; i < announcementInfo[0].length; i++) {
      if (announcementInfo[0][i] != '') {
        announcements.add(
          ClubAnnouncement(
            date: DateFormat.yMMMMd().format(DateTime.parse('1899-12-30').add(Duration(days: int.parse(announcementInfo[0][i])))),
            clubName: announcementInfo[1][i],
            clubColour: 'ff${clubColours[announcementInfo[1][i]]!.substring(1)}',
            title: announcementInfo[2][i],
            body: announcementInfo[3][i],
          )
        );
      } else {
        break;
      }
    }
  }
}