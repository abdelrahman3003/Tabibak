import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget(
      {super.key,
      required this.context,
      required this.title,
      required this.subtitle,
      required this.confirmString,
      this.confirmColor,
      required this.isLoading,
      this.onPressed});
  final BuildContext context;
  final String title;
  final String subtitle;
  final String confirmString;
  final Color? confirmColor;
  final bool isLoading;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      content: Text(title, style: Theme.of(context).textTheme.titleMedium),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: SizedBox(
            height: 25.h,
            width: 25.w,
            child: FittedBox(
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(5),
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      )
                    : Text(confirmString)),
          ),
        ),
      ],
    );
  }
}
