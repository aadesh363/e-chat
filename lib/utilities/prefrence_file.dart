import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences prefs;

  static Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setBool({
    required String key,
    required bool value,
  }) async {
    await prefs.setBool(key, value);
  }

  static bool getBool({required String key}) {
    return prefs.getBool(key) ?? false;
  }
  static Future<void> setString({required String key, required String value}) async {
    await prefs.setString(key ,value);
  }
  static String getString({required String action}){
    String start = prefs.getString(action)?? "";
    return start;
  }
}