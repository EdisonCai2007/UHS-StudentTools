import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    loadEvents();
  }

  static Future loadEvents() async {
    events = [];

    final fetchedEvents = await fetchEvents();

    for (var event in fetchedEvents['items']) {
      events.add(EventDetails(event['summary'], event['start']['date'] ?? event['start']['dateTime'], event['end']['date'] ?? event['end']['dateTime']));
    }
  }
}

class EventDetails {
  String title;
  String startDate;
  String endDate;
  String startTime = '';
  String endTime = '';

  EventDetails(this.title, this.startDate, this.endDate) {
    if (startDate.length == 25) {
      startTime = startDate.substring(11, 19);
      startDate = startDate.substring(0, 10);
    }

    if (endDate.length == 25) {
      endTime = endDate.substring(11, 19);
      endDate = endDate.substring(0, 10);
    }
  }

  @override
  String toString() {
    return 'Title: $title   |   Start Date: $startDate   |   Start Time: $startTime   |   End Date: $endDate   |   End Time: $endTime';
  }
}

// If event adding is gunna be added, for filtering by date, add a "filterValue"
// variable, which is simply the same value as the date plus start time variables,
// but without the dashes or colons, and the lower the "filterValue", the more
// recent the event would be.
// Example: "2025-04-11" & "18:12:00" --> "20250411181200"