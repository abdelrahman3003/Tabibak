import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/presentaion/view/screens/appointments_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/home_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/search_screen.dart';
import 'package:tabibak/features/profile/presentation/view/screens/profile_screen.dart';

final indexScreenProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

class LayoutScreen extends ConsumerWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(indexScreenProvider);
    final textStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.primary);
    final screens = [
      HomeScreen(),
      AppointmentsScreen(),
      SearchScreen(),
      ProfileScreen()
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: screens[selectedIndex],
            ),
            GNav(
              gap: 12,
              activeColor: AppColors.primary,
              color: AppColors.primary,
              tabBackgroundColor: AppColors.second,
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                ref.read(indexScreenProvider.notifier).state = index;
              },
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              tabMargin: EdgeInsets.only(top: 4),
              tabs: [
                GButton(
                    icon: Icons.home,
                    text: AppStrings.home.tr(),
                    textStyle: textStyle),
                GButton(
                    icon: Icons.event,
                    text: AppStrings.bookings.tr(),
                    textStyle: textStyle),
                GButton(
                    icon: Icons.search,
                    text: AppStrings.search.tr(),
                    textStyle: textStyle),
                GButton(
                    icon: Icons.settings,
                    text: AppStrings.settings.tr(),
                    textStyle: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
