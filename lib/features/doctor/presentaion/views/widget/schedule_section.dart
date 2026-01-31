import 'package:flutter/material.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/clinic_work_day_card.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, this.workingDayList});
  final List<WorkingDay>? workingDayList;
  @override
  Widget build(BuildContext context) {
    final workingDays = _getCleanList(workingDayList);
    return ClinicWorkDayCard(
      workingDay: workingDays[0],
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
