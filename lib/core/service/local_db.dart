import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static late final SharedPreferences _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _pref.setString(key, value);
  }

  static String? getString(String key) {
    return _pref.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _pref.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _pref.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _pref.setInt(key, value);
  }

  static int? getInt(String key) {
    return _pref.getInt(key);
  }
}
