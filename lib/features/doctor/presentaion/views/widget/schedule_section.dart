import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/schedule_row_item.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TitleText(title: AppStrings.workingHours),
                  Spacer(),
                  _buildTextShift(context, AppStrings.morning),
                  55.wBox,
                  _buildTextShift(context, AppStrings.evening),
                  20.wBox
                ],
              ),
              10.hBox,
              Column(
                children: List.generate(
                  _getCleanList(workingDayList!).length,
                  (index) => ScheduleRowItem(
                    day: workingDays[index].day.dayEn ?? "",
                    morning: workingDays[index].shiftMorning?.start ?? "",
                    evening: workingDays[index].shiftEvening?.end ?? "",
                  ),
                ),
              ),
            ],
          );
  }

  Text _buildTextShift(BuildContext context, String shift) {
    return Text(
      shift,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold),
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
