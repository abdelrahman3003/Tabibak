import 'package:flutter/material.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/shedule_row_item.dart';

import '../../../../data/model/doctor_model.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, this.workingDayList});
  final List<ClinicWorkingDay>? workingDayList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        workingDayList!.length,
        (index) => SheduleRowItem(
            day: workingDayList?[index].workingDay?.days?.day ?? "",
            start: workingDayList?[index].workingDay?.times?.start ?? "",
            end: workingDayList?[index].workingDay?.times?.end ?? ""),
      ),
    );
  }
}
