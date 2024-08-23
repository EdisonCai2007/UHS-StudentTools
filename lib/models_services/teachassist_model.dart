import 'dart:async';

import 'package:http/http.dart' as http;


const String LOGINURL = 'https://ta.yrdsb.ca/yrdsb/index.php';
const String COURSEURL = 'https://ta.yrdsb.ca/live/students/listReports.php?';
const String GUIDANCEDATEURL = 'https://ta.yrdsb.ca/live/students/bookAppointment.php?';

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
    );

    // print(res.statusCode);
    // print(res.headers);
    // print(res.body);
    if (res.statusCode == 302) {
      var cookies = [res.headersSplitValues['set-cookie']?[5].substring(14,27),res.headersSplitValues['set-cookie']?[6].substring(11,17)];
      // print(cookies);
      return cookies;
    } else {
      throw ['Failed to Authorize User'];
    }
  } catch (e) {
    return ['Invalid Login'];
  }
}

Future<String> fetchMarks(username, password) async {
  var cookies = await authorizeUser(username, password);

  try {
    http.Response response = await http.get(
      Uri.parse('${COURSEURL}student_id=${cookies[1]}'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'session_token=${cookies[0]}; student_id=${cookies[1]}',
      },
    );

    
    // log('body==${response.body}');
    if (response.statusCode == 200) {
      return "Bob";
    } else {
      throw Exception('Failed to load TeachAssist Marks');
    }
  } catch (e) {
    throw Exception('Failed to load TeachAssist Marks');
  }
}

Future<List<String>> fetchGuidanceDate(username, password) async {
  var cookies = await authorizeUser(username, password);

  try {
    http.Response response = await http.get(
      Uri.parse('${GUIDANCEDATEURL}school_id=2&student_id=${cookies[1]}&inputDate=2024-08-20'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': 'session_token=${cookies[0]}; student_id=${cookies[1]}',
      },
    );


    // log('body==${response.body}');
    if (response.statusCode == 200) {
      return response.body.split("\n");
    } else {
      throw Exception('Failed to load TeachAssist Marks');
    }
  } catch (e) {
    throw Exception('Failed to load TeachAssist Marks');
  }
}
