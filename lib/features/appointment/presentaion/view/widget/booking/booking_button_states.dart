import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_confirm_dialog.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class BookingButtonStates extends ConsumerWidget {
  const BookingButtonStates({super.key, required this.doctorModel});
  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentBookingNotiferProvider);
    return AppButton(
      isDisabled: state.selectedTime == null,
      title: AppStrings.book,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => BookingConfirmDialog(doctorModel: doctorModel),
        );
      },
    );
  }
}
