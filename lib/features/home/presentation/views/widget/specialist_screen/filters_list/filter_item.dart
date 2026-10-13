import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.text,
    this.isActive = false,
    this.onTap,
    this.icon,
    this.trailing,
  });

  final String text;
  final bool isActive;
  final VoidCallback? onTap;
  final Widget? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : theme.cardColor,
          borderRadius: AppRadius.radius20,
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary
                : (isDark ? Colors.white12 : Colors.black12),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                6.wBox,
              ],
              Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isActive ? AppColors.white : null,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
              if (trailing != null) ...[
                4.wBox,
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
