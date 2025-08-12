import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/categories_list/categories_list_view.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_list_view.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/welcom_panner.dart';

import 'widget/home_screen/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: HomeAppbar(),
        ),
        20.hBox,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: WelcomPanner()),
        40.hBox,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitelText(title: StringConstants.doctorSpeciality.tr())),
        20.hBox,
        CategoriesListView(),
        20.hBox,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TitelText(title: StringConstants.recommendationDoctor.tr())),
        20.hBox,
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DoctorListView(),
        ))
      ],
    );
  }
}
