import 'dart:convert';
import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/models_services/events_model.dart';

class ApiLimitChecker {
  // -=-  Google Calendar API  -=-days
  /*late DateTime eventsRequestDate;

  bool eventsCheck() {
    if (sharedPrefs.eventsRequestDate == '' || DateTime.now().subtract(const Duration(days: 1)).isAfter(DateTime.parse(sharedPrefs.eventsRequestDate))) {
      eventsRequestDate = DateTime.now();
      sharedPrefs.eventsData = EventsModel.events.map((event) => jsonEncode(event.toJson())).toList();
      return true;
    } else {
      return false;
    }
  }*/
}