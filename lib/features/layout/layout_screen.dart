import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/presentation/controller/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/favourite_view.dart';
import 'package:tabibak/features/home/presentation/views/home_screen/home_screen.dart';
import 'package:tabibak/features/home/presentation/views/setting_view.dart';

import '../home/presentation/views/appointments_view.dart';

class LayoutScreen extends ConsumerWidget {
  const LayoutScreen({super.key});

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
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: screens[selectedIndex],
          )),
          GNav(
            gap: 12,
            backgroundColor: Colors.white,
            activeColor: AppColors.primary,
            color: AppColors.primary,
            tabBackgroundColor: AppColors.second,
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              ref.read(indexScreenProvider.notifier).state = index;
            },
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
            tabMargin: EdgeInsets.only(top: 8),
            tabs: [
              GButton(icon: Icons.home, text: 'الصفحة الرئيسة'),
              GButton(icon: Icons.favorite, text: 'المفضلة'),
              GButton(icon: Icons.event, text: 'الحجزات'),
              GButton(icon: Icons.settings, text: "الإعدادات"),
            ],
          ),
        ],
      ),
    );
  }
}
