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
            data = Map<String, dynamic>.from(jsonDecode(payload) as Map);
          } catch (_) {}
        }
        AppNavigator.pushNamed(
          Routes.notificationScreen,
          arguments: data,
        );
      },
    );
    // Foreground FCM -> just refresh the notifications list from Supabase.
    _fgSub = PushNotificationService.foregroundMessages.stream.listen((msg) {
      try {
        ref.read(notificationProviderNotifier.notifier).fetchNotifications();
      } catch (_) {}
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
