import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences prefs;

  SharedPrefsService._();

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}

class SharedPrefKeys {
  static const String userToken = 'userToken';
  static const String step = 'step';
}
