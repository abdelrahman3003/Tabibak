import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationServices {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController.broadcast();
  static bool _initialized = false;

  static void onTap(NotificationResponse notificationResponse) {
    if (!streamController.isClosed) {
      streamController.add(notificationResponse);
    }
  }

  static Future<void> init() async {
    if (_initialized) return;
    const androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    // Default channel for appointment / general notifications (Android 8+).
    const channel = AndroidNotificationChannel(
      'tabibak_notifications',
      'Tabibak notifications',
      description: 'Appointment updates, reminders and offers',
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  static Map<String, String> _stringifyData(Map<String, dynamic> data) {
    return data.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
  }

  static Future<void> showBasicNotification(RemoteMessage remoteMessage) async {
    await init();
    String? imageUrl = remoteMessage.notification?.android?.imageUrl ?? "";
    BigPictureStyleInformation? bigPictureStyle;

    if (imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          bigPictureStyle = BigPictureStyleInformation(
            ByteArrayAndroidBitmap(response.bodyBytes),
            contentTitle: remoteMessage.notification?.title,
            summaryText: remoteMessage.notification?.body,
          );
        }
      } catch (e) {
        log("Failed to load notification image: $e");
      }
    }

    final payload = jsonEncode(_stringifyData(remoteMessage.data));

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "tabibak_notifications",
        "Tabibak notifications",
        channelDescription: 'Appointment updates, reminders and offers',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyle,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // Stable-ish id per notification so multiple notifications don't
    // overwrite each other.
    final rawId = remoteMessage.data['notification_id']?.toString() ??
        remoteMessage.messageId ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final id = rawId.hashCode & 0x7fffffff;

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: remoteMessage.notification?.title ?? remoteMessage.data['title'],
      body: remoteMessage.notification?.body ?? remoteMessage.data['body'],
      notificationDetails: notificationDetails,
      payload: payload.isEmpty ? null : payload,
    );
  }

  /// Shows a local notification from an explicit title/body/payload pair
  /// (used for background messages that arrive as data-only).
  static Future<void> showManualNotification({
    required String? title,
    required String? body,
    Map<String, dynamic> data = const {},
  }) async {
    await init();
    final payload = jsonEncode(_stringifyData(data));
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        "tabibak_notifications",
        "Tabibak notifications",
        channelDescription: 'Appointment updates, reminders and offers',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    final rawId = data['notification_id']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    await flutterLocalNotificationsPlugin.show(
      id: rawId.hashCode & 0x7fffffff,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}
