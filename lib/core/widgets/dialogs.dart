import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';

class Dialogs {
  static successDialog(BuildContext context, String title, subtitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: 90.r,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppButton(
                title: AppStrings.close,
                color: AppColors.green,
                padding: EdgeInsets.symmetric(vertical: 10),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  static errorDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.unknownErrorOccurred,
                style:
                    Apptextstyles.font16Blackebold.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    Apptextstyles.font14BlackReqular.copyWith(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppButton(
                title: AppStrings.close,
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
