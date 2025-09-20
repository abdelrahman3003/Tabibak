import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/booking/appointments_screen.dart';
import 'package:tabibak/features/home/presentation/views/screens/favourite_view.dart';
import 'package:tabibak/features/home/presentation/views/screens/home_screen.dart';
import 'package:tabibak/features/profile/presentation/view/screens/profile_screen.dart';

final indexScreenProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

class LayoutScreen extends ConsumerWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(indexScreenProvider);
    final screens = [
      HomeScreen(),
      AppointmentsScreen(),
      FavouriteView(),
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              tabMargin: EdgeInsets.only(top: 8),
              tabs: [
                GButton(icon: Icons.home, text: AppStrings.home.tr()),
                GButton(icon: Icons.event, text: AppStrings.bookings.tr()),
                GButton(icon: Icons.search, text: AppStrings.favorites.tr()),
                GButton(icon: Icons.settings, text: AppStrings.settings.tr()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
