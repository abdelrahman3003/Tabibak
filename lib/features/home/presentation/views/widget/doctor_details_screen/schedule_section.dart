import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';

import '../../../../data/model/doctor_model.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key, this.workingDayList});
  final List<ClinicWorkingDay>? workingDayList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        workingDayList!.length,
        (index) => _buildScheduleRow(
            day: workingDayList?[index].workingDay?.days?.day ?? "",
            start: workingDayList?[index].workingDay?.times?.start ?? "",
            end: workingDayList?[index].workingDay?.times?.end ?? ""),
      ),
    );
  }

  static Widget _buildScheduleRow(
      {required String day, required String start, required String end}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(day, style: Apptextstyles.font16blackRegular),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 50.w,
                  child: Center(
                    child: Text(
                      start,
                      style: Apptextstyles.font16blackRegular
                          .copyWith(color: AppColors.textLight),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // مسافة بين النصين
                SizedBox(
                  width: 50.w,
                  child: Center(
                    child: Text(
                      end, // بدل ما تعيد start حط المتغير التاني
                      style: Apptextstyles.font16blackRegular
                          .copyWith(color: AppColors.textLight),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
