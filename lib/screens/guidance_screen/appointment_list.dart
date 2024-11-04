import 'dart:async';

import 'package:html/dom.dart' as dom;
import 'package:wolfpackapp/misc/internet_connection.dart';

import 'package:wolfpackapp/misc/shared_prefs.dart';
import 'package:wolfpackapp/misc/time_converter.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';


bool appointmentListLoaded = false;
List<Map<String, String>> appointmentList = [];

Future initAppointmentList(int range) async {
  if (await checkUserConnection()) {
    DateTime day = DateTime.now();

    for (int i = 0; i < range; i++) {
      dom.Document guidanceDateHtmlData = await fetchGuidanceDate(sharedPrefs.username, sharedPrefs.password, day.toString().split(" ")[0]);
      for (final data in guidanceDateHtmlData
          .querySelectorAll('body > div > div.yellow_message.box')
          .map((element) => element.innerHtml.trim())
          .toList()) {
        List<String> parsedData = parseAppointmentList(data);
        appointmentList.add({'Name': parsedData[0], 'Date': parsedData[1], 'Action': parsedData[2]});
      }
      day = day.add(const Duration(days:1));
    }
    appointmentListLoaded = true;
  }
}

List<String> parseAppointmentList(String data) {
  return [
    data.substring(data.indexOf(' :') + 3, data.indexOf(':',data.indexOf(' :') + 3)),

    '${data.substring(5, data.indexOf(' :')).split(' ')[0]} ${TimeConverter.get12Format(data.substring(0, data.indexOf(' :')).split(' ')[1])}',

    data.substring(data.indexOf('.php?') + 5, data.indexOf('">') + 5),
  ];
}