import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.color,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.padding,
    this.textColor,
    this.isLoadingSide = false,
    this.isDisabled = false,
    this.fontSize,
    this.borderRadius,
  });

  final Color? color;
  final Color? textColor;
  final String title;
  final bool isLoading;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final bool isLoadingSide;
  final bool isDisabled;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(5.r),
        ),
        padding: padding ?? EdgeInsets.symmetric(vertical: 16.h),
        backgroundColor: isDisabled
            ? Theme.of(context).colorScheme.secondary
            : (color ?? AppColors.primary),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: isLoading
          ? Center(
              child: SizedBox(
                height: 16.h,
                width: 16.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            )
          : Stack(
              children: [
                Center(
                  child: Text(title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: AppColors.white)),
                ),
                if (isLoadingSide)
                  Positioned(
                    right: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
