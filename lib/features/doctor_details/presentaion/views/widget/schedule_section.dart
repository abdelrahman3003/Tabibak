import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor_details/presentaion/views/widget/shedule_row_item.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';

import '../../../../home/data/model/doctor_model.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, this.workingDayList});
  final List<ClinicWorkingDay>? workingDayList;
  @override
  Widget build(BuildContext context) {
    return workingDayList == null || workingDayList!.isEmpty
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitelText(title: AppStrings.workingHours),
              10.hBox,
              Column(
                children: List.generate(
                  workingDayList!.length,
                  (index) => SheduleRowItem(
                      day: workingDayList?[index].workingDay?.days?.day ?? "",
                      start:
                          workingDayList?[index].workingDay?.times?.start ?? "",
                      end: workingDayList?[index].workingDay?.times?.end ?? ""),
                ),
              ),
            ],
          );
  }
}
