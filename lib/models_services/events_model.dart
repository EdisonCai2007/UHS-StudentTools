import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../misc/shared_prefs.dart';

const String CALENDAR_ID = 'unionville.hs@gapps.yrdsb.ca';

/*
const String URL = 'https://calendar.google.com/calendar/u/0/embed?mode=AGENDA&src=unionville.hs@gapps.yrdsb.ca';
// Backup: https://calendar.google.com/calendar/u/0/embed?title=News+and+Events&showTitle=0&showNav=0&showDate=0&showPrint=0&showTabs=0&showCalendars=0&showTz=0&mode=AGENDA&height=300&wkst=1&bgcolor=%23cccccc&src=unionville.hs@gapps.yrdsb.ca&color=%232952A3&ctz=America/New_York
*/

Future<Map<String, dynamic>> fetchEvents() async {
  try {
    final currentTime = DateTime.now().toUtc();
    final minTimeString = currentTime.toIso8601String();

    final response = await http.get(
        Uri.parse('https://www.googleapis.com/calendar/v3/calendars/$CALENDAR_ID/events?key=${dotenv.env['CALENDAR_API_KEY']}&timeMin=$minTimeString&singleEvents=true&orderBy=startTime'),
        headers: {'Content-Type': 'application/json'}
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw('Failed to load events response! (1)');
    }
  } catch (e) {
    throw('Failed to load events response! (2)');
  }
}

class EventsModel {
  static List<EventDetails> events = [];

  Future init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (sharedPrefs.eventsData.isEmpty || sharedPrefs.eventsRequestDate.isEmpty || DateTime.now().subtract(const Duration(days: 1)).isAfter(DateTime.parse(sharedPrefs.eventsRequestDate))) {
      loadEvents();
    }
  }

  static Future loadEvents() async {
    events = [];

    final fetchedEvents = await fetchEvents();

    for (var event in fetchedEvents['items']) {
      if (event['start']['date'] != null) {
        events.add(EventDetails(event['summary'], event['start']['date'], event['end']['date'], '', ''));
      } else {
        events.add(EventDetails(event['summary'], event['start']['dateTime'].substring(0, 10), event['end']['dateTime'].substring(0, 10), event['start']['dateTime'].substring(11, 19), event['end']['dateTime'].substring(11, 19)));
      }
    }

    sharedPrefs.eventsRequestDate = DateTime.now().toString();
    sharedPrefs.eventsData = EventsModel.events.map((event) => jsonEncode(event.toJson())).toList();
  }
}

class EventDetails {
  String title;
  String startDate;
  String endDate;
  String startTime;
  String endTime;

  EventDetails(this.title, this.startDate, this.endDate, this.startTime, this.endTime);

  @override
  String toString() {
    return 'Title: $title   |   Start Date: $startDate   |   Start Time: $startTime   |   End Date: $endDate   |   End Time: $endTime';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      json['title'],
      json['startDate'],
      json['endDate'],
      json['startTime'],
      json['endTime'],
    );
  }
}

// If event adding is gunna be added, for filtering by date, add a "filterValue"
// variable, which is simply the same value as the date plus start time variables,
// but without the dashes or colons, and the lower the "filterValue", the more
// recent the event would be.
// Example: "2025-04-11" & "18:12:00" --> "20250411181200"