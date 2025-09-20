import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/router.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tabibak',
            theme: AppTheme.darkTheme,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: initRout(),
          );
        });
  }

  String initRout() {
    if (SharedPrefsService.prefs.getInt(SharedPrefKeys.step) == 1) {
      return Routes.layoutScreen;
    }
    return Routes.singinView;
  }
}
