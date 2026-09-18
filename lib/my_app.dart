import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/routing/app_navigator.dart';
import 'package:tabibak/core/routing/router.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/services/local_notification_services.dart';
import 'package:tabibak/core/services/push_notification_service.dart';
import 'package:tabibak/core/theme/app_theme.dart';
import 'package:tabibak/features/notification/data/model/notification_model.dart';
import 'package:tabibak/features/notification/presentation/manager/notification_provider/notification_provider.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_provider.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription? _notifSub;
  StreamSubscription? _fgSub;

  @override
  void initState() {
    super.initState();
    // Taps on local notifications (foreground / background) -> inbox screen.
    _notifSub = LocalNotificationServices.streamController.stream.listen(
      (response) {
        Map<String, dynamic> data = {};
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            data = Map<String, dynamic>.from(
              jsonDecode(payload) as Map,
            );
          } catch (_) {}
        }
        AppNavigator.pushNamed(
          Routes.notificationScreen,
          arguments: data,
        );
      },
    );
    // Foreground FCM -> update inbox immediately (realtime fallback).
    _fgSub = PushNotificationService.foregroundMessages.stream.listen((msg) {
      try {
        final data = msg.data;
        final idRaw = data['notification_id']?.toString();
        final id = idRaw != null ? int.tryParse(idRaw) : null;
        final notifier = ref.read(notificationProviderNotifier.notifier);
        if (id != null) {
          final title =
              msg.notification?.title ?? data['title']?.toString() ?? '';
          final body =
              msg.notification?.body ?? data['body']?.toString() ?? '';
          notifier.handleRemoteInsert(
            NotificationModel(
              id: id,
              userId: '',
              title: title,
              body: body,
              type: AppNotificationType.fromString(data['type']?.toString()),
              data: Map<String, dynamic>.from(data),
              isRead: false,
              createdAt: DateTime.now(),
            ),
          );
        } else {
          // No id (e.g. doctor-side or legacy payload): just refresh counts.
          notifier.fetchNotifications();
        }
      } catch (_) {
        try {
          ref.read(notificationProviderNotifier.notifier).fetchNotifications();
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    _notifSub?.cancel();
    _fgSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeStateProvider);

    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: scaffoldMessengerKey,
            navigatorKey: AppNavigator.key,
            title: 'Tabibak',
            theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: Routes.splashScreen,
          );
        });
  }
}
