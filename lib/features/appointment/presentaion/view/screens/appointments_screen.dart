import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment/appointment_list_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/filters_list/filter_list.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPadding.all16,
        child: Column(
          children: [
            10.hBox,
            TitleText(title: AppStrings.appointments),
            20.hBox,
            SizedBox(
                height: 40,
                child: FilterList(filters: ["السابقه ", "القادمة"])),
            10.hBox,
            Expanded(child: AppointmentListStates()),
          ],
        ),
      ),
    );
  }
}
