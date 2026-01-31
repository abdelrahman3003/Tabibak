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
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: AppRadius.radius8),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Color(0xff94A3B8)),
          ),
          SizedBox(height: 5),
          FittedBox(
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
