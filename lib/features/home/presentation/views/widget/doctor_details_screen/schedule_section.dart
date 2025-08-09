import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildScheduleRow('السبت', '9:00 ص - 5:00 م'),
        _buildScheduleRow('الأحد', '9:00 ص - 5:00 م'),
        _buildScheduleRow('الاثنين', '9:00 ص - 5:00 م'),
        _buildScheduleRow('الثلاثاء', '9:00 ص - 5:00 م'),
        _buildScheduleRow('الأربعاء', '9:00 ص - 5:00 م'),
        _buildScheduleRow('الخميس', '9:00 ص - 3:00 م'),
        _buildScheduleRow('الجمعة', 'إجازة'),
      ],
    );
  }

  static Widget _buildScheduleRow(String day, String time) {
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
          Text(time,
              style: Apptextstyles.font16blackRegular
                  .copyWith(color: AppColors.textLight)),
        ],
      ),
    );
  }
}
