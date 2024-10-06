import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  // -=-  API Requests Limiting  -=-
  String get eventsRequestDate => _sharedPrefs.getString('eventsRequestDate') ?? '';
  set eventsRequestDate(String value) {
    _sharedPrefs.setString('eventsRequestDate', value);
  }
  List<String> get eventsData => _sharedPrefs.getStringList('eventsData') ?? [];
  set eventsData(List<String> value) {
    _sharedPrefs.setStringList('eventsData', value);
  }


  // -=-  UI Changing  -=-
  bool get isLightTheme => _sharedPrefs.getBool('isLightTheme') ?? false;
  set isLightTheme(bool value) {
    _sharedPrefs.setBool('isLightTheme', value);
  }

  bool get blurCourseOverview => _sharedPrefs.getBool('blurCourseOverview') ?? false;
  set blurCourseOverview(bool value) {
    _sharedPrefs.setBool('blurCourseOverview', value);
  }


  // -=-  Teachassist Login Information  -=-
  String get username => _sharedPrefs.getString('taUsername') ?? '';
  set username(String value) {
    _sharedPrefs.setString('taUsername', value);
  }

  String get password => _sharedPrefs.getString('taPassword') ?? '';
  set password(String value) {
    _sharedPrefs.setString('taPassword', value);
  }

  // -=-  Teachassist HTML Information  -=-
  String get studentData => _sharedPrefs.getString('taStudentData') ?? '';
  set studentData(String value) {
    _sharedPrefs.setString('taStudentData', value);
  }

  String get courseData => _sharedPrefs.getString('taCourseData') ?? '';
  set courseData(String value) {
    _sharedPrefs.setString('taCourseData', value);
  }
}

final sharedPrefs = SharedPrefs();