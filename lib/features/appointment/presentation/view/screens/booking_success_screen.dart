import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentation/view/widget/booking/appointment_success_arg.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.appointmentSuccessArg});
  final AppointmentSuccessArg appointmentSuccessArg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 48.r,
                    color: AppColors.green,
                  ),
                ),
                24.hBox,
                Text(
                  AppStrings.bookingConfirmed,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                8.hBox,
                Text(
                  AppStrings.appointmentBookedSuccessfully,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.subtextColor,
                  ),
                ),
                40.hBox,
                AppButton(
                  title: AppStrings.goBack,
                  onPressed: () {
                    context.pushNamedAndRemoveUntil(
                        Routes.layoutScreen, (route) => true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
