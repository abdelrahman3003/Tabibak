import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/services/force_update_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;
  bool _updateRequired = false;

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

  void _navigateNext() async {
    final updateRequired = await ForceUpdateService.isUpdateRequired();
    if (!mounted) return;
    if (updateRequired) {
      setState(() => _updateRequired = true);
      return;
    }

    final isOnboarding =
        SharedPrefsService.prefs.getBool(SharedPrefKeys.isOnboarding) ?? false;

    final supabase = getIt<Supabase>().client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      final userData = await supabase
          .from('users')
          .select('city_id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (userData == null) {
        context.pushNamedAndRemoveUntil(
          Routes.selectCityScreen,
          (route) => false,
        );
        return;
      }

      final cityId = userData['city_id'];

      if (cityId == null) {
        context.pushNamedAndRemoveUntil(
          Routes.selectCityScreen,
          (route) => false,
        );
        return;
      }

      context.pushNamedAndRemoveUntil(
        Routes.layoutScreen,
        (route) => false,
      );

      return;
    }

    if (isOnboarding) {
      context.pushNamedAndRemoveUntil(
        Routes.singInScreen,
        (route) => false,
      );
    } else {
      context.pushNamedAndRemoveUntil(
        Routes.onboardingScreen,
        (route) => false,
      );
    }
  }

  Future<void> _openStore() async {
    final storeUrl = ForceUpdateService.storeUrl;
    final uri = Uri.tryParse(storeUrl);
    if (uri != null && uri.hasScheme) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_updateRequired) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(28.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.system_update_alt, size: 72.sp, color: AppColors.white),
                    SizedBox(height: 24.h),
                    Text('updateRequiredTitle'.tr(), textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12.h),
                    Text('updateRequiredMessage'.tr(), textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.white)),
                    SizedBox(height: 28.h),
                    SizedBox(width: double.infinity, child: FilledButton(
                      onPressed: _openStore,
                      child: Text('updateNow'.tr()),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
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
                "assets/images/splash.png",
                color: AppColors.white,
                height: 150.h,
                width: 250.w,
                fit: BoxFit.cover,
              ),
              Text(
                "طبيبك",
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
