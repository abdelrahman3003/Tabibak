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
    this.width,
    this.height,
    this.minHeight,
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
  final double? width;
  final double? height;
  final double? minHeight;

  /// Responsive font size based on screen width
  double _responsiveFontSize(BuildContext context) {
    if (fontSize != null) return fontSize!.sp;
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 13.sp; // Small phones
    if (screenWidth < 480) return 14.sp; // Normal phones
    if (screenWidth < 768) return 15.sp; // Large phones
    if (screenWidth < 1024) return 16.sp; // Tablets
    return 16.sp; // Desktops / large tablets
  }

  /// Responsive indicator size
  double _indicatorSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 18.r;
    if (screenWidth < 768) return 22.r;
    return 24.r;
  }

  /// Responsive vertical padding
  EdgeInsetsGeometry _responsivePadding(BuildContext context) {
    if (padding != null) return padding!;
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w);
    }
    if (screenWidth < 768) {
      return EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w);
    }
    return EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w);
  }

  Color _resolveBackgroundColor(BuildContext context) {
    if (isDisabled) return Theme.of(context).colorScheme.secondary;
    return color ?? AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final indicatorSize = _indicatorSize(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5.r),
          ),
          padding: _responsivePadding(context),
          backgroundColor: _resolveBackgroundColor(context),
          minimumSize: Size(0, minHeight ?? 48.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: isDisabled ? 0 : 2,
        ),
        onPressed:
            (isLoading || isLoadingSide || isDisabled) ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: indicatorSize,
                width: indicatorSize,
                child: CircularProgressIndicator(
                  color: textColor ?? Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    // Reserve space on the right if side loader is shown
                    padding: isLoadingSide
                        ? EdgeInsets.only(right: (indicatorSize + 8.w))
                        : EdgeInsets.zero,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDisabled
                                ? (textColor ?? Colors.white)
                                    .withValues(alpha: .6)
                                : (textColor ?? AppColors.white),
                            fontSize: _responsiveFontSize(context),
                          ),
                    ),
                  ),
                  if (isLoadingSide)
                    Positioned(
                      right: 0,
                      child: SizedBox(
                        height: indicatorSize - 4.r,
                        width: indicatorSize - 4.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: textColor ?? Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
