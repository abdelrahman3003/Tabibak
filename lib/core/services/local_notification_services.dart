import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationServices {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    InitializationSettings settings = const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  static void showBasicNotification(RemoteMessage remoteMessage) async {
    String? imageUrl = remoteMessage.notification?.android?.imageUrl ?? "";
    BigPictureStyleInformation? bigPictureStyle;

    if (imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));

        bigPictureStyle = BigPictureStyleInformation(
          ByteArrayAndroidBitmap(response.bodyBytes),
          contentTitle: remoteMessage.notification?.title,
          summaryText: remoteMessage.notification?.body,
        );
      } catch (e) {
        log("Failed to load notification image: $e");
      }
    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "id_1",
        "basic notification",
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyle, // ✅ safe, can be null
      ),
    );

    await flutterLocalNotificationsPlugin.show(
        id: 0,
        title: remoteMessage.notification?.title,
        body: remoteMessage.notification?.body,
        notificationDetails: notificationDetails);
  }
}
