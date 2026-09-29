import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
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
  bool _exitDialogOpen = false;
  bool _forceUpdateDialogOpen = false;

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
      await _showForceUpdateDialog();
      return;
    }

    final isOnboarding =
        SharedPrefsService.prefs.getBool(SharedPrefKeys.isOnboarding) ?? false;

    final supabase = getIt<Supabase>().client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      final userData = await supabase
          .from('users')
          .select('district_id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (userData == null) {
        context.pushNamedAndRemoveUntil(
          Routes.selectCityScreen,
          (route) => false,
        );
        return;
      }

      final districtId = userData['district_id'];

      if (districtId == null) {
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

  Future<void> _showForceUpdateDialog() async {
    _forceUpdateDialogOpen = true;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: AlertDialog(
            icon: Icon(
              Icons.system_update_alt,
              size: 44.sp,
              color: AppColors.primary,
            ),
            title: Text(
              'updateRequiredTitle'.tr(),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'updateRequiredMessage'.tr(),
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _openStore,
                  child: Text('updateNow'.tr()),
                ),
              ),
            ],
          ),
        ),
      );
    } finally {
      _forceUpdateDialogOpen = false;
    }
  }

  Future<void> _confirmExit() async {
    if (_exitDialogOpen || _forceUpdateDialogOpen || !mounted) return;
    _exitDialogOpen = true;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('exitDialogTitle'.tr()),
        content: Text('exitDialogMessage'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('stayInApp'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('exitApp'.tr()),
          ),
        ],
      ),
    );
    _exitDialogOpen = false;
    if (shouldExit == true) await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
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
      ),
    );
  }
}
