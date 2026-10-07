import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class ClinicItemInfo extends StatelessWidget {
  const ClinicItemInfo(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});
  final String icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all12,
      decoration: BoxDecoration(
        borderRadius: AppRadius.radius8,
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            height: 22,
            width: 22,
            fit: BoxFit.contain,
          ),
          20.wBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.subtextColor, fontSize: 14.sp),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
