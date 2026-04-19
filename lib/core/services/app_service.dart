import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/services/local_notification_services.dart';
import 'package:tabibak/core/services/push_notification_service.dart';

import 'env_service.dart';
import 'subbase_service.dart';

class AppService {
  AppService._();

  static Future<void> init() async {
    await EnvService.init();
    await SharedPrefsService.init();
    await SupabaseService.init();
    await Future.wait([
      LocalNotificationServices.init(),
      PushNotificationService.init(),
    ]);
    setupServiceLocator();
  }
}
