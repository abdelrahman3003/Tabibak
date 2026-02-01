import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title, this.subtitle, this.onTap});
  final String title;
  final String? subtitle;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        ),
        if (subtitle != null)
          InkWell(
            onTap: onTap,
            child: Text(subtitle!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.primary)),
          ),
      ],
    );
  }
}
