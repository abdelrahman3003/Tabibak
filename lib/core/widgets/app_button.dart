import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';

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
  });

  final Color? color;
  final Color? textColor;
  final String title;
  final bool isLoading;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final bool isLoadingSide;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: isDisabled
            ? Theme.of(context).colorScheme.secondary
            : (color ?? AppColors.primary),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: isLoadingSide && isLoading
          ? Center(
              child: SizedBox(
                height: 15.h,
                width: 14.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Stack(
              children: [
                Center(
                  child: Text(
                    title,
                    style: Apptextstyles.font16Blackebold.copyWith(
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ),
                if (isLoading && !isLoadingSide)
                  Positioned(
                    right: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        height: 20,
                        width: 20,
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
