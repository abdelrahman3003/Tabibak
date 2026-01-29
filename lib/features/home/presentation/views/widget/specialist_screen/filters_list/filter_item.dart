import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class FilterItem extends StatelessWidget {
  const FilterItem(
      {super.key, required this.text, this.isActive = false, this.onTap});
  final String text;
  final bool isActive;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
            color:
                isActive ? Theme.of(context).colorScheme.primary : Colors.white,
            borderRadius: AppRadius.radius20),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isActive ? AppColors.white : null,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
