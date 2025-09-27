import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_not_available.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/booking_time.dart';

class BookingTimeStates extends StatelessWidget {
  const BookingTimeStates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(appointmentBookingNotiferProvider);
        return state.selectedDate == null || state.isLoading
            ? SizedBox()
            : state.workingDay == null
                ? BookingNotAvailable()
                : BookingTime(shifts: state.workingDay!.shifts!);
      },
    );
  }
}
