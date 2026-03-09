import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/clinic_work_day_card.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, this.workingDayList});
  final List<WorkingDay>? workingDayList;
  @override
  Widget build(BuildContext context) {
    final workingDays = _getCleanList(workingDayList);
    return workingDays.isEmpty
        ? SizedBox()
        : Column(
            children: [
              30.hBox,
              TitleText(title: AppStrings.workingHours),
              10.hBox,
              Column(
                  children: List.generate(
                workingDays.length,
                (index) => ClinicWorkDayCard(workingDay: workingDays[index]),
              )),
            ],
          );
  }
}

List<WorkingDay> _getCleanList(List<WorkingDay>? workingDayList) {
  List<WorkingDay> list = [];
  if (workingDayList == null) return [];
  for (var workday in workingDayList) {
    if (workday.isSelected!) {
      list.add(workday);
    }
  }
  return list;
}
