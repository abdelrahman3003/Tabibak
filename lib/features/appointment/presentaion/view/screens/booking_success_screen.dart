import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_padding.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/appointment_success_arg.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.appointmentSuccessArg});
  final AppointmentSuccessArg appointmentSuccessArg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppPadding.all16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHeader(context),
                20.hBox,
                _buildDoctorInfo(context),
                10.hBox,
                _buildDateInfo(context),
                20.hBox,
                _buildTimeInfo(context),
                Spacer(),
                _buildButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.bookingConfirmed,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        20.hBox,
        Text(
          AppStrings.bookingSuccessful,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
        ),
        40.hBox,
        Text(
          AppStrings.appointmentBookedSuccessfully,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo(BuildContext context) {
    return Row(
      children: [
        ImageCircle(
          radius: 28,
          urlImage: appointmentSuccessArg.doctorModel.image,
        ),
        12.wBox,
        Text(appointmentSuccessArg.doctorModel.name ?? "",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: AppPadding.all16,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : AppColors.borderLight,
                borderRadius: AppRadius.radius8),
            child: const Icon(Icons.date_range_outlined)),
        12.wBox,
        Text(appointmentSuccessArg.appointmentModel.appointmentDate ?? "",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final model = ref.read(appointmentBookingNotifierProvider).dayShiftsModel;
      final timeString =
          appointmentSuccessArg.appointmentModel.shiftMorningId != null
              ? "${model?.morning?.start ?? ''} - ${model?.morning?.end ?? ''}"
              : "${model?.evening?.start ?? ''} - ${model?.evening?.end ?? ''}";
      return Row(
        children: [
          Container(
              padding: AppPadding.all16,
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : AppColors.borderLight,
                  borderRadius: AppRadius.radius8),
              child: const Icon(Icons.timelapse)),
          12.wBox,
          Text(timeString, style: Theme.of(context).textTheme.bodyLarge),
        ],
      );
    });
  }

  AppButton _buildButton(BuildContext context) {
    return AppButton(
      title: "الرجوع",
      onPressed: () {
        context.pushNamedAndRemoveUntil(Routes.layoutScreen, (route) => true);
      },
    );
  }
}
