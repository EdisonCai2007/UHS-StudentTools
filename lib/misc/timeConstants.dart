import 'dart:collection';

import 'package:wolfpackapp/models_services/teachassist_model.dart';

const int beforeSchool = 0; // 12:00 AM
const int period1Start = 505; // 8:25 AM
const int period2Start = 585; // 9:45 AM
const int period3Start = 665; // 11:05 AM
const int period4Start = 745; // 12:25 PM
const int period5Start = 825; // 1:45 PM
const int afterSchool = 905; // 3:05 PM
var list = [beforeSchool, period1Start, period2Start, period3Start, period4Start, period5Start, afterSchool];

class TimeConstants {
  final HashMap<int, String> timeToPeriod = HashMap();
  final HashMap<int, String> periodToTimestamp = HashMap();

  TimeConstants() {
    timeToPeriod[beforeSchool] = "Before School";
    timeToPeriod[period1Start] = "Period 1";
    timeToPeriod[period2Start] = "Period 2";
    timeToPeriod[period3Start] = "Period 3";
    timeToPeriod[period4Start] = "Period 4";
    timeToPeriod[period5Start] = "Period 5";
    timeToPeriod[afterSchool] = "After School";

    periodToTimestamp[beforeSchool] = " ";
    periodToTimestamp[period1Start] = "8:25 AM - 9:45 AM";
    periodToTimestamp[period2Start] = "9:45 AM - 11:05 AM";
    periodToTimestamp[period3Start] = "11:05 AM - 12:25 PM";
    periodToTimestamp[period4Start] = "12:25 PM - 1:45 PM";
    periodToTimestamp[period5Start] = "1:45 PM - 3:05 PM";
    periodToTimestamp[afterSchool] = " ";
  }

  List<String> getPeriod(currentTime) {
    for (int x = list.length-1; x >= 0; x--) {
      if (currentTime >= list[x]) {
        return [timeToPeriod[list[x]]!,periodToTimestamp[list[x]]!];
      }
    }
    return [timeToPeriod[afterSchool]!,periodToTimestamp[afterSchool]!];
  }

  double getPeriodProgress(currentTime) {
    if (currentTime >= afterSchool) {
      return 1;
    } else if (currentTime < period1Start) {
      return 0;
    }

    for (int x = list.length-1; x >= 0; x--) {
      if (currentTime >= list[x]) {
        return (currentTime - list[x]) / (list[x+1] - list[x]);
      }
    }
    return 0;
  }

  List<String> getPeriodClass(currentTime) {
    final period = getPeriod(currentTime)[0].replaceAll(RegExp('[^0-9]'), '');

    if (period != '') {
      for (var course in TeachAssistModel.courses) {
        if (course['Period'].contains(period) && course['Semester'] == 1) {
          return ['${course['Code']} : ${course['Name']}',
            'Period ${course['Period'].toString().substring(1,course['Period'].toString().length-1).replaceAll(',', ' & ')}',
          'Rm. ${course['Room']}'];
        }
      }
      return ['Lunch / Spare','',''];
    } else {
      return ['','',''];
    }
  }
}
