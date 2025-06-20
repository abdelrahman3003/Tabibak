import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/class/routes.dart';
import 'package:tabibak/core/networking/app_service.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
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
            initialRoute: initRout(),
          );
        });
  }

  String initRout() {
    if (AppService.sharedPreferences.getInt(ShardedPrefKey.step) == 1) {
      return Routes.homeView;
    }
    return Routes.singinView;
  }
}
