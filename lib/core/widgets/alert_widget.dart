import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';

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
      content: Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.cancel),
        ),
        SizedBox(
          width: 70.w,
          child: FittedBox(
            child: AppButton(
              padding: AppPadding.all8,
              title: confirmString,
              isLoading: isLoading,
              onPressed: onPressed,
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}
