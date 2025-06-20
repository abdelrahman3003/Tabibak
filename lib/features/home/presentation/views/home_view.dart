import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/favourite_view.dart';
import 'package:tabibak/features/home/presentation/views/home_screen/home_screen.dart';
import 'package:tabibak/features/home/presentation/views/setting_view.dart';

import 'appointments_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(indexScreenProvider);
    final screens = [
      HomeScreen(),
      FavouriteView(),
      AppointmentsView(),
      SettingView()
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: screens[selectedIndex],
            )),
            GNav(
              gap: 8,
              backgroundColor: Colors.white,
              activeColor: AppColors.primary,
              color: AppColors.primary,
              tabBackgroundColor: AppColors.second,
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                ref.read(indexScreenProvider.notifier).state = index;
              },
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              tabs: [
                GButton(icon: Icons.home, text: 'الصفحة الرئيسة'),
                GButton(icon: Icons.favorite, text: 'المفضلة'),
                GButton(icon: Icons.event, text: 'الحجزات'),
                GButton(icon: Icons.settings, text: "الإعدادات"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
