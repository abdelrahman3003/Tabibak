import 'package:flutter/material.dart';
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

      // _buildScheduleRow(workingDay?.day ?? "",
      //     workingDay?.times?.start.toString() ?? "غير معروف"),
      // _buildScheduleRow(workingDay?.day ?? "",
      //     workingDay?.times?.start.toString() ?? "غير معروف")
      // _buildScheduleRow('الأحد', '9:00 ص - 5:00 م'),
      // _buildScheduleRow('الاثنين', '9:00 ص - 5:00 م'),
      // _buildScheduleRow('الثلاثاء', '9:00 ص - 5:00 م'),
      // _buildScheduleRow('الأربعاء', '9:00 ص - 5:00 م'),
      // _buildScheduleRow('الخميس', '9:00 ص - 3:00 م'),
      // _buildScheduleRow('الجمعة', 'إجازة'),
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
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(day, style: Apptextstyles.font16blackRegular),
            ],
          ),
          Text("$start  --  $end",
              style: Apptextstyles.font16blackRegular
                  .copyWith(color: AppColors.textLight)),
        ],
      ),
    );
  }
}
