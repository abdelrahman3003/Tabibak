import 'env_service.dart';
import 'shared_pref_service.dart';
import 'subbase_service.dart';

class AppService {
  AppService._();

  static Future<void> init() async {
    await EnvService.init();
    await SharedPrefsService.init();
    await SupabaseService.init();
  }
}
