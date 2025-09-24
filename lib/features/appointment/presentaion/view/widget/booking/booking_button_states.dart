import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/core/widgets/dialogs.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';

class BookingButtonStates extends ConsumerWidget {
  const BookingButtonStates({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentBookingNotiferProvider);
    return AppButton(
      isDisabled: state.selectedTime == null,
      title: AppStrings.confirmBooking,
      onPressed: () {
        Dialogs.successDialog(context, AppStrings.bookingConfirmed,
            AppStrings.appointmentBookedSuccessfully);
      },
    );
  }
}
