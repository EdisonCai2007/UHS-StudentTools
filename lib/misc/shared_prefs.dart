import 'package:shared_preferences/shared_preferences.dart';
import '../models_services/events_model.dart';

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


  // -=-  Theme Changing  -=-
  bool get isLightTheme => _sharedPrefs.getBool('isLightTheme') ?? false;
  set isLightTheme(bool value) {
    _sharedPrefs.setBool('isLightTheme', value);
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
}

final sharedPrefs = SharedPrefs();