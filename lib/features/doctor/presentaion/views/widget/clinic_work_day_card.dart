import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/doctor/presentaion/views/widget/shift_schedule_item.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

class ClinicWorkDayCard extends StatelessWidget {
  const ClinicWorkDayCard({super.key, required this.workingDay});
  final WorkingDay workingDay;
  @override
  Widget build(BuildContext context) {
    log("-----${formatTime(workingDay.shiftMorning?.start)}");
    return Container(
      width: double.infinity,
      padding: AppPadding.all12,
      decoration: BoxDecoration(
          color: Color(0xffEDF2F7),
          borderRadius: AppRadius.radius8,
          border: Border.all(
            color: const Color(0xffE2E8F0), // أغمق درجة واحدة بس
            width: 1,
          )),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.date_range,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 4),
              Text(
                workingDay.day.dayAr ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, height: 20 / 25),
              ),
            ],
          ),
          12.hBox,
          Row(
            children: [
              Expanded(
                  child: ShiftScheduleItem(
                      title: "مسائي",
                      subtitle:
                          "${formatTime(workingDay.shiftMorning?.start)} - ${formatTime(workingDay.shiftMorning?.end)} ")),
              14.wBox,
              Expanded(
                  child: ShiftScheduleItem(
                      title: "مسائي",
                      subtitle:
                          "${formatTime(workingDay.shiftEvening?.start)} - ${formatTime(workingDay.shiftEvening?.end)} ")),
            ],
          )
        ],
      ),
    );
  }
}
