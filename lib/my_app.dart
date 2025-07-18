import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tabibak/core/class/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tabibak',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBG,
        fontFamily: 'Tajawal',
      ),
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.singinView,
    );
  }
}
