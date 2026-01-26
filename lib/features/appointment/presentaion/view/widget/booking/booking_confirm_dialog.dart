import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class BookingConfirmDialog extends ConsumerWidget {
  const BookingConfirmDialog({super.key, required this.doctorModel});
  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(appointmentBookingNotifierProvider.select(
      (state) => true,
    ));
    final provider = ref.read(appointmentBookingNotifierProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.appointmentDetails
                .tr(namedArgs: {"dayName": "", "date": "", "time": ""})),
            10.hBox,
            Text(
              "${AppStrings.consultationPrice}: ${doctorModel.clinic?.consultationFee ?? AppStrings.unknown} ${AppStrings.egp}",
              style: const TextStyle(fontSize: 14),
            ),
            5.hBox,
            Text(
              "${AppStrings.doctor}: ${doctorModel.name}",
              style: const TextStyle(fontSize: 14),
            ),
            20.hBox,
            AppButton(
              title: AppStrings.confirmBooking,
              isLoading: isLoading,
              onPressed: () async {
                // await ref
                //     .read(appointmentBookingNotiferProvider.notifier)
                //     .bookingAppointment(context, doctorModel.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
