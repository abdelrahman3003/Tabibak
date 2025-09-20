import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences prefs;

  SharedPrefsService._();

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
}

class SharedPrefKeys {
  static const String userToken = 'userToken';
  static const String step = 'step';
  static const String lang = "lang";
  static const String isDark = "isDark";
}
