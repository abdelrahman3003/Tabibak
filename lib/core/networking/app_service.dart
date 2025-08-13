// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AppService {
//   static late SharedPreferences sharedPreferences;
//   AppService._() {
//     initialData();
//   }
//   static Future<void> initialData() async {
//     initDotenv();
//     await initSupabaseService();
//     initializeSharedPreferences();
//   }

//   static Future<void> initializeSharedPreferences() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//   }

//   static initSupabaseService() async {
//     final apiKey = dotenv.env['API_KEY'];
//     final baseUrl = dotenv.env['BASE_URL'];
//     await Supabase.initialize(
//       url: baseUrl!,
//       anonKey: apiKey!,
//     );
//   }

//   static initDotenv() async {
//     await dotenv.load(fileName: ".env");
//   }
// }

// class ShardedPrefKey {
//   static String userToken = 'userToken';
//   static String step = "step";
// }
