import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/firebase_options.dart';
import 'package:tabibak/my_app.dart';

import 'core/services/app_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();
  await AppService.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(ProviderScope(
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: "assets/langs",
      startLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  ));
}
