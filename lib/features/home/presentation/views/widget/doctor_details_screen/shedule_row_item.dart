import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class SheduleRowItem extends StatelessWidget {
  const SheduleRowItem(
      {super.key, required this.day, required this.start, required this.end});
  final String day;
  final String start;
  final String end;
  @override
  Widget build(BuildContext context) {
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
                Text(day, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 50.w,
                  child: Center(
                    child: Text(
                      start,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 50.w,
                  child: Center(
                    child: Text(end,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
