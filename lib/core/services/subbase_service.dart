import 'package:supabase_flutter/supabase_flutter.dart';

import 'env_service.dart';

class SupabaseService {
  SupabaseService._();

  static Future<void> init() async {
    final apiKey = EnvService.apiKey;
    final baseUrl = EnvService.baseUrl;

    if (apiKey == null || baseUrl == null) {
      throw Exception("API_KEY أو BASE_URL غير موجودين في ملف .env");
    }

    await Supabase.initialize(url: baseUrl, anonKey: apiKey);
  }
}
