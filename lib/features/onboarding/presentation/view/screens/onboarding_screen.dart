import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/onboarding/data/model/onboarding_model.dart';
import 'package:tabibak/features/onboarding/presentation/view/widget/dot_indicator.dart';
import 'package:tabibak/features/onboarding/presentation/view/widget/onboarding_body.dart';
import 'package:tabibak/features/onboarding/presentation/view/widget/skip_button.dart';

final onboardingControllerProvider = StateProvider<int>((ref) => 0);

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  static final List<OnboardingModel> _onboardingData = [
    OnboardingModel(
      title: 'OnboardingTitle1',
      subtitle: 'OnboardingSubtitle1',
      image: 'assets/images/onboarding/doctor.png',
    ),
    OnboardingModel(
      title: 'OnboardingTitle2',
      subtitle: 'OnboardingSubtitle2',
      image: 'assets/images/onboarding/booking.png',
    ),
    OnboardingModel(
      title: 'OnboardingTitle3',
      subtitle: 'OnboardingSubtitle3',
      image: 'assets/images/onboarding/security.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await SharedPrefsService.prefs.setInt(SharedPrefKeys.step, 1);
    if (!mounted) return;
    context.pushNamedAndRemoveUntil(Routes.singInScreen, (route) => false);
  }

  void _nextPage(int currentPage) {
    if (currentPage == _onboardingData.length - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SkipButton(onPressed: _completeOnboarding),
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) =>
                    ref.read(onboardingControllerProvider.notifier).state = index,
                itemBuilder: (context, index) =>
                    OnboardingBody(model: _onboardingData[index]),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (index) => DotIndicator(isActive: index == currentPage),
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                      title: currentPage == _onboardingData.length - 1
                          ? 'Get Started'.tr()
                          : 'Next'.tr(),
                      onPressed: () => _nextPage(currentPage),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
