import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_provider.dart';

class BookingDate extends StatelessWidget {
  const BookingDate({super.key, required this.clinicID});
  final int clinicID;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(appointmentBookingNotiferProvider);
      ref.watch(appointmentBookingNotiferProvider.notifier);
      return InkWell(
        onTap: () async {
          ref
              .read(appointmentBookingNotiferProvider.notifier)
              .selectDate(context, clinicID);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            state.selectedDate == null
                ? AppStrings.selectDate
                : "${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    });
  }
}
