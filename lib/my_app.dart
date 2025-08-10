import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/routes.dart';
import 'package:tabibak/core/services/shared_pref_service.dart';
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
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: Routes.generateRoute,
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
