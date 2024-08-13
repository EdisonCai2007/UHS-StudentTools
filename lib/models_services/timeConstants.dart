import 'dart:collection';

const int beforeSchool = 0; // 12:00 AM
const int period1Start = 505; // 8:25 AM
const int period2Start = 585; // 9:45 AM
const int period3Start = 665; // 11:05 AM
const int period4Start = 745; // 12:25 AM
const int period5Start = 825; // 1:45 PM
const int afterSchool = 905; // 3:05 PM
var list = [beforeSchool, period1Start, period2Start, period3Start, period4Start, period5Start, afterSchool];

class TimeConstants {
  HashMap<int, String> timeToPeriod = HashMap();

  TimeConstants() {
    timeToPeriod[beforeSchool] = "Before School";
    timeToPeriod[period1Start] = "Period 1";
    timeToPeriod[period2Start] = "Period 2";
    timeToPeriod[period3Start] = "Period 3";
    timeToPeriod[period4Start] = "Period 4";
    timeToPeriod[period5Start] = "Period 5";
    timeToPeriod[afterSchool] = "After School";
  }

  String getPeriod(currentTime) {
    for (int x = list.length-1; x >= 0; x--) {
      if (currentTime >= list[x]) {
        return timeToPeriod[list[x]] ?? "Error";
      }
    }
    return timeToPeriod[afterSchool] ?? "Error";
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
}
