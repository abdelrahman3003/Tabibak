import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;

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
  static const _deviceIdKey = 'notification_device_id';
  static String? _deviceId;

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
    if (token != null) {
      await _cacheToken(token);
    }
    try {
      await syncTokenToSupabase(token);
    } catch (e) {
      log('------- device registration failed: $e');
    }

    // Keep server token fresh.
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log("------- fcm token refreshed");
      await _cacheToken(newToken);
      try {
        await syncTokenToSupabase(newToken);
      } catch (e) {
        log('------- device registration failed: $e');
      }
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

  /// Keeps the legacy user token and the authenticated user's device record
  /// in sync. Edge functions can then target the current device by user ID.
  static Future<bool> syncTokenToSupabase(String? token) async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) return true;

      final deviceId = await _getDeviceId();
      final registered = await client.rpc('register_my_device', params: {
        'p_device_id': deviceId,
        'p_fcm_token': token,
        'p_platform': _platformName,
      });
      if (registered != true) return false;

      if (token != null) {
        try {
          await _cacheToken(token);
        } catch (_) {}
        try {
          await client.from('users').update({
            'fcm_token': token,
          }).eq('user_id', user.id);
        } catch (e) {
          // The device registry is authoritative; legacy sync is best-effort.
          log('------- legacy token sync failed: $e');
        }
      }
      return true;
    } catch (e) {
      log("------- sync token failed: $e");
      rethrow;
    }
  }

  static String get _platformName {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'other';
  }

  static Future<String> _getDeviceId() async {
    if (_deviceId != null) return _deviceId!;
    final prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(_deviceIdKey);
    if (value == null || value.isEmpty) {
      final random = Random.secure();
      value = List.generate(
        32,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();
      await prefs.setString(_deviceIdKey, value);
    }
    _deviceId = value;
    return value;
  }

  /// Call after login / signup to bind the device token to the user row.
  static Future<bool> syncCurrentToken() async {
    final token = await getToken();
    return syncTokenToSupabase(token);
  }

  static Future<void> unsubscribe() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final deviceId = await _getDeviceId();
      if (user != null) {
        await Supabase.instance.client.rpc('unregister_my_device', params: {
          'p_device_id': deviceId,
        });
      }
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
