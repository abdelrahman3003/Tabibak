import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/function/formate_date.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/doctor/presentation/views/widget/shift_schedule_item.dart';
import 'package:tabibak/features/home/data/model/working_day_model.dart';

class ClinicWorkDayCard extends StatelessWidget {
  const ClinicWorkDayCard({super.key, required this.workingDay});
  final WorkingDay workingDay;
  bool _isValidShift(dynamic shift) {
    if (shift == null) return false;
    final start = shift.start as String?;
    final end = shift.end as String?;
    return start != null &&
        start.trim().isNotEmpty &&
        end != null &&
        end.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final hasMorning = _isValidShift(workingDay.shiftMorning);
    final hasEvening = _isValidShift(workingDay.shiftEvening);

    if (!hasMorning && !hasEvening) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: AppPadding.all12,
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor.withAlpha(5)
              : const Color(0xffEDF2F7),
          borderRadius: AppRadius.radius8,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withAlpha(1)
                : const Color(0xffE2E8F0),
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
                context.locale.languageCode == 'ar'
                    ? workingDay.day.dayAr ?? ""
                    : workingDay.day.dayEn ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          12.hBox,
          Row(
            children: [
              if (hasMorning)
                Expanded(
                    child: ShiftScheduleItem(
                        title: AppStrings.morningShift,
                        subtitle:
                            "${formatTime(workingDay.shiftMorning?.start)} - ${formatTime(workingDay.shiftMorning?.end)} ")),
              if (hasMorning && hasEvening) 14.wBox,
              if (hasEvening)
                Expanded(
                    child: ShiftScheduleItem(
                        title: AppStrings.eveningShift,
                        subtitle:
                            "${formatTime(workingDay.shiftEvening?.start)} - ${formatTime(workingDay.shiftEvening?.end)} ")),
            ],
          )
        ],
      ),
    );
  }
}
