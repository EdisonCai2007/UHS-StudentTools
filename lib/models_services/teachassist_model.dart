import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import '../misc/shared_prefs.dart';

const String LOGINURL = 'https://ta.yrdsb.ca/yrdsb/index.php';
const String COURSEURL = 'https://ta.yrdsb.ca/live/students/listReports.php';
const String GUIDANCEDATEURL = 'https://ta.yrdsb.ca/live/students/bookAppointment.php';

Future<List<String?>> authorizeUser(String username, String password) async {
  try {
    var res = await http.post(
        Uri.parse(LOGINURL),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'subject_id': '0',
          'username': username,
          'password': password,
          'submit': 'Login',
        }
    ).timeout(const Duration(milliseconds: 1000));

     //print("statusCode === ${res.statusCode}");
     //print("headers === ${res.headers}");
     //print("body === ${res.body}");
    if (res.statusCode == 302) {
      var cookies = [
        res.headersSplitValues['set-cookie']?[5].substring(14, res.headersSplitValues['set-cookie']?[5].indexOf(';',14)),
        res.headersSplitValues['set-cookie']?[6].substring(11, 17)
      ];
      //print("cookies === $cookies");
      return cookies;
    } else {
      throw ['Failed to Authorize User'];
    }
  } catch (e) {
    return ['Invalid Login'];
  }
}

Future<dom.Document> fetchMarks(username, password) async {
  var cookies = await authorizeUser(username, password);

  try {
    http.Response response = await http.get(
      Uri.parse('$COURSEURL?student_id=${cookies[1]}'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'session_token=${cookies[0]}; student_id=${cookies[1]}',
      },
    );

    // log('body==${response.body}');
    if (response.statusCode == 200) {
      return dom.Document.html(response.body);
    } else {
      throw Exception('Failed to load TeachAssist Marks');
    }
  } catch (e) {
    throw Exception('Failed to load TeachAssist Marks');
  }
}

Future<dom.Document> fetchGuidanceDate(username, password, date) async {
  var cookies = await authorizeUser(username, password);

  try {
    http.Response response = await http.get(
      Uri.parse(
          '$GUIDANCEDATEURL?school_id=2&student_id=${cookies[1]}&inputDate=$date'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'session_token=${cookies[0]}; student_id=${cookies[1]}',
      },
    );

    // log('code==${response.statusCode}');
    // log('headers==${response.headers}');
    // log('body==${response.body}');
    if (response.statusCode == 200) {
      return dom.Document.html(response.body);
    } else {
      throw Exception('Failed to load Guidance Appointments');
    }
  } catch (e) {
    throw Exception('Failed to load Guidance Appointments');
  }
}

Future<dom.Document> fetchGuidanceTime (username, password, string) async {
  var cookies = await authorizeUser(username, password);

  try {
    http.Response response = await http.get(
      Uri.parse(
          '$GUIDANCEDATEURL?$string'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'session_token=${cookies[0]}; student_id=${cookies[1]}',
      },
    );

    // log('code==${response.statusCode}');
    // log('headers==${response.headers}');
    // log('body==${response.body}');
    if (response.statusCode == 200) {
      return dom.Document.html(response.body);
    } else {
      throw Exception('Failed to load Guidance Appointments');
    }
  } catch (e) {
    throw Exception('Failed to load Guidance Appointments');
  }
}

Future<dom.Document> bookGuidanceAppointment (username, password, dt, tm, id, school_id, reason, withParent, online) async {
  var cookies = await authorizeUser(username, password);

  try {
    http.Response response = await http.post(
      Uri.parse(GUIDANCEDATEURL),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'session_token=${cookies[0]}; student_id=${cookies[1]}',
      },
      body: {
        'dt': dt,
        'tm': tm,
        'id': id,
        'action': '',
        'inputDate': '',
        'school_id': school_id,
        'reason': reason ?? '',
        'withParent': withParent ?? '',
        'online': online ?? '',
        'submit': 'Submit Reason',
      }
    );

    // log('code==${response.statusCode}');
    // log('headers==${response.headers}');
    // log('body==${response.body}');
    if (response.statusCode == 200) {
      return dom.Document.html(response.body);
    } else {
      throw Exception('Failed to load Guidance Appointments');
    }
  } catch (e) {
    throw Exception('Failed to load Guidance Appointments');
  }
}

class TeachAssistModel {
  static List<Map<String, dynamic>> courses = [];
  static List<String>? rawData;

  Future init() async {
    final fetchedData = await fetchMarks(sharedPrefs.username, sharedPrefs.password);
    rawData = fetchedData.querySelectorAll('body > div > div > div > table > tbody > tr > td')
        .map((element) => element.text.trim().replaceAll(RegExp('[\t\n]'), ''))
        .toList();
    loadCourses();
  }

  static Future loadCourses() async {
    courses = [];
    for (int i = 0; i < ((rawData!.length - 1) / 3).floor(); i++) {
      courses.add(<String, dynamic>{});
      courses[i]['Code'] = rawData![i * 3]
          .substring(0, rawData![i * 3].indexOf(':')-1);
      courses[i]["Name"] = rawData![i * 3]
          .substring(rawData![i * 3].indexOf(':')+2, rawData![i * 3].indexOf('Block:'));
      courses[i]["Period"] = rawData![i * 3]
          .substring(rawData![i * 3].indexOf('Block:') + 7,rawData![i * 3].indexOf('  - '))
          .trim().replaceAll('P', '').split(',');
      courses[i]["Room"] = rawData![i * 3]
          .substring(rawData![i * 3].indexOf('  - ')+8);
      courses[i]["Semester"] = rawData![i * 3 + 1].substring(6,7) == '9' ? 1 : 2;
      courses[i]["Course Average"] = (rawData![i * 3 + 2].contains('=')) ? rawData![i * 3 + 2].substring(
          rawData![i * 3 + 2].indexOf('=')+1,rawData![i * 3 + 2].indexOf('%')) : null;

      // print(courses[i]);
      // print(courses[i]['Code'] );
    }
  }

  static Future clearCourses() async {
    courses = [];
  }
}