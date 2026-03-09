import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opacity = 1;
      });
      Future.delayed(const Duration(milliseconds: 1200), () {
        _navigateNext();
      });
    });
  }

  void _navigateNext() {
    bool isOnboarding =
        SharedPrefsService.prefs.getBool(SharedPrefKeys.isOnboarding)!;
    final user = getIt<Supabase>().client.auth.currentUser;
    if (user != null) {
      context.pushNamedAndRemoveUntil(Routes.layoutScreen, (route) => false);
      return;
    }
    if (isOnboarding) {
      context.pushNamedAndRemoveUntil(Routes.singInScreen, (route) => false);
      return;
    } else {
      context.pushNamedAndRemoveUntil(
          Routes.onboardingScreen, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/app_logo.png",
                color: AppColors.white,
                height: 150.h,
                width: 220.w,
                fit: BoxFit.cover,
              ),
              Text(
                " طبيبك",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
