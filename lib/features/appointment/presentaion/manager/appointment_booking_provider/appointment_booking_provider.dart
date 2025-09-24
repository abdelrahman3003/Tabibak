import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_states.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_provider/appointment_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

final appointmentBookingNotiferProvider = StateNotifierProvider.autoDispose<
    AppointmentBookingProvider, AppointmentBookingStates>(
  (ref) => AppointmentBookingProvider(ref),
);

class AppointmentBookingProvider
    extends StateNotifier<AppointmentBookingStates> {
  AppointmentBookingProvider(this.ref) : super(AppointmentBookingStates());

  final Ref ref;
  selectDate(BuildContext context, int doctorId) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      locale: Localizations.localeOf(context),
    );
    if (picked != null) {
      state = AppointmentBookingStates(selectedDate: picked);
      String dayName =
          DateFormat.EEEE(Localizations.localeOf(context).toString())
              .format(picked);
      await getClinicTimes(doctorId, dayName);
    }
  }

  selectTime(TimeSlot time) {
    state = state.copyWith(selectedTime: time);
  }

  getClinicTimes(int doctorId, String workingDay) async {
    state = state.copyWith(isLoading: true);
    final result =
        await ref.read(appointmentsRepos).getTimeSlots(doctorId, workingDay);
    result.when(
      sucess: (data) {
        state = state.copyWith(workingDay: data, isLoading: false);
      },
      failure: (apiErrorModel) {},
    );
  }
}
