import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get username => _sharedPrefs.getString('taUsername') ?? "";

  set username(String value) {
    _sharedPrefs.setString('taUsername', value);
  }

  String get password => _sharedPrefs.getString('taPassword') ?? "";

  set password(String value) {
    _sharedPrefs.setString('taPassword', value);
  }
}

final sharedPrefs = SharedPrefs();