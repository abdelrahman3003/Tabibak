import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_button.dart';

class Dialogs {
  static authErrorDialog(BuildContext context, String? error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("خطأ"),
          content: Text(error ?? "حدث خطأ غير معروف"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("حسنًا"),
            ),
          ],
        );
      },
    );
  }

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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),

              // العنوان
              Text(
                title,
                style: Apptextstyles.font16Blackebold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // النص
              Text(
                subtitle,
                style:
                    Apptextstyles.font14BlackReqular.copyWith(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              AppButton(
                title: "إغلاق",
                color: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 10),
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
                "حدث خطأ",
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
                title: "إغلاق",
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
