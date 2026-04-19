import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tabibak/core/services/local_notification_services.dart';

class PushNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await firebaseMessaging.requestPermission();

    String? token = await getToken();
    log("------- token $token");

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static Future<String?> getToken() async {
    String? token;
    if (Platform.isIOS) {
      // Wait for APNs token first — required on iOS
      final apnsToken = await firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        token = await firebaseMessaging.getToken();
      } else {
        log("------- APNs token not available (likely a simulator)");
      }
    } else {
      token = await firebaseMessaging.getToken();
    }
    return token;
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    LocalNotificationServices.showBasicNotification(message);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    log("---- message  ${message.notification?.title}");
  }
}
