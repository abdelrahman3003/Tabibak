import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/shedule_row_item.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/title_text.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, this.workingDayList});
  final List<WorkingDay>? workingDayList;
  @override
  Widget build(BuildContext context) {
    return workingDayList == null || workingDayList!.isEmpty
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
                  workingDayList!.length,
                  (index) => SheduleRowItem(
                    day: workingDayList?[index].day.dayEn ?? "",
                    morning: workingDayList?[index].shifts?.morningStart ?? "",
                    evening: workingDayList?[index].shifts?.morningStart ?? "",
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
