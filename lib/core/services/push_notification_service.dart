import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/routing/app_navigator.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/services/local_notification_services.dart';

/// Top-level background handler (must stay top-level for FCM).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("---- background message ${message.notification?.title}");
  // Notification-payload messages are displayed by the OS automatically.
  // Data-only messages need an explicit local notification — best effort.
  if (message.notification == null && message.data.isNotEmpty) {
    try {
      await LocalNotificationServices.showManualNotification(
        title: message.data['title'] as String?,
        body: message.data['body'] as String?,
        data: message.data,
      );
    } catch (e) {
      log("---- background local-notif failed: $e");
    }
  }
}

class PushNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// Broadcasts foreground FCM messages so the UI layer (notification
  /// inbox) can insert them even if realtime is momentarily disconnected.
  static final StreamController<RemoteMessage> foregroundMessages =
      StreamController<RemoteMessage>.broadcast();

  static Future<void> init() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await getToken();
    log("------- fcm token $token");
    if (token != null) {
      await _cacheToken(token);
      await syncTokenToSupabase(token);
    }

    // Keep server token fresh.
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log("------- fcm token refreshed");
      await _cacheToken(newToken);
      await syncTokenToSupabase(newToken);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // App launched from a terminated state via notification.
    final initial = await firebaseMessaging.getInitialMessage();
    if (initial != null) {
      _handleMessageOpenedApp(initial);
    }
  }

  static Future<String?> getToken() async {
    try {
      String? token;
      if (Platform.isIOS) {
        // Wait for APNs token first — required on iOS.
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
    } catch (e) {
      log("------- getToken failed: $e");
      return null;
    }
  }

  static Future<void> _cacheToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    } catch (e) {
      log("------- cache token failed: $e");
    }
  }

  /// Writes the current FCM token to the logged-in user's row so edge
  /// functions can target this device. No-op when logged out.
  static Future<void> syncTokenToSupabase(String token) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      await Supabase.instance.client.from('users').update({
        'fcm_token': token,
      }).eq('user_id', user.id);
    } catch (e) {
      log("------- sync token failed: $e");
    }
  }

  /// Call after login / signup to bind the device token to the user row.
  static Future<void> syncCurrentToken() async {
    final token = await getToken();
    if (token != null) {
      await _cacheToken(token);
      await syncTokenToSupabase(token);
    }
  }

  static Future<void> unsubscribe() async {
    try {
      await firebaseMessaging.deleteToken();
    } catch (e) {
      log("------- delete token failed: $e");
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    LocalNotificationServices.showBasicNotification(message);
    if (!foregroundMessages.isClosed) {
      foregroundMessages.add(message);
    }
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    log("---- opened from notification ${message.data}");
    // Refresh inbox first; NotificationScreen marks notification_id as read.
    AppNavigator.pushNamed(
      Routes.notificationScreen,
      arguments: message.data,
    );
  }
}
