import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/sliver_app_delegete.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/welcom_panner.dart';

import '../widget/home_screen/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.hBox,
                HomeAppbar(),
                20.hBox,
                WelcomPanner(),
              ],
            ),
          ),
          SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                minHeight: 155.h,
                maxHeight: 155.h,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.hBox,
                      TitelText(title: AppStrings.doctorSpeciality.tr()),
                      10.hBox,
                      CategoriesListStates(),
                    ],
                  ),
                ),
              )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TitelText(title: AppStrings.recommendationDoctor.tr()),
            ),
          ),
        ],
        body: Column(
          children: [
            Expanded(child: DoctorListStates()),
          ],
        ),
      ),
    );
  }
}
