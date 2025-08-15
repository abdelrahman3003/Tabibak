import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_consatnt.dart';

import 'env_service.dart';

class SupabaseService {
  SupabaseService._();

  static Future<void> init() async {
    final apiKey = EnvService.apiKey;
    final baseUrl = ApiConstants.supabaseApi;

    if (apiKey == null) {
      throw Exception("API_KEY أو BASE_URL غير موجودين في ملف .env");
    }

    await Supabase.initialize(url: baseUrl, anonKey: apiKey);
  }
}
