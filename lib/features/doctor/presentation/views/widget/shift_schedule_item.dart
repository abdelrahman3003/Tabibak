import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class ShiftScheduleItem extends StatelessWidget {
  const ShiftScheduleItem(
      {super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: AppRadius.radius8),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xff64748B)), // Slightly darker/bigger for readability
          ),
          SizedBox(height: 6),
          FittedBox(
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, 
                  color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
