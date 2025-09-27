import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/my_app.dart';

import 'core/services/app_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await AppService.init();

  runApp(ProviderScope(
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: "assets/langs",
      startLocale: const Locale('ar'),
      fallbackLocale: Locale('ar'),
      child: const MyApp(),
    ),
  ));
}
