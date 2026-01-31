import 'package:flutter/material.dart';
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
        border: Border.all(
          color: const Color(0xff000000).withValues(alpha: 0.08),
          width: 1,
        ),
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
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: AppColors.subtextColor),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
