import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class SheduleRowItem extends StatelessWidget {
  const SheduleRowItem(
      {super.key,
      required this.day,
      required this.morning,
      required this.evening});
  final String day;
  final String? morning;
  final String? evening;
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
            Spacer(),
            _buildTimeRow(context, morning),
            20.wBox,
            _buildTimeRow(context, evening),
          ],
        ));
  }

  _buildTimeRow(BuildContext context, String? timteSlot) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 2),
      child: timteSlot == null
          ? Text(
              "--",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timteSlot ?? AppStrings.unknown,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "-",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  timteSlot ?? AppStrings.unknown,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
    );
  }
}
