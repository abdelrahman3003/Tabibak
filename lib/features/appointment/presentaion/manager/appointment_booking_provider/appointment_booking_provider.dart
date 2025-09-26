import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/widgets/dialogs.dart';
import 'package:tabibak/features/appointment/data/model/appointment_body.dart';
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

  bookingAppointment(BuildContext context, int doctorId) async {
    state = state.copyWith(isDialogLoading: true);
    final result =
        await ref.read(appointmentsRepos).addAppointment(AppointmentBody(
              doctorId: doctorId,
              userId: Supabase.instance.client.auth.currentUser!.id,
              appointmentTime: _convertTimeSlot(state.selectedTime),
              appointmentDate: state.selectedDate!,
              status: 1,
            ));
    result.when(
      sucess: (data) {
        state = state.copyWith(isAdded: true);
        context.pop();

        Dialogs.successDialog(
            context, AppStrings.success, AppStrings.bookingSuccess);
      },
      failure: (apiErrorModel) {
        state = state.copyWith();
        Dialogs.errorDialog(context, AppStrings.unknownErrorOccurred);
      },
    );
  }

  String _convertTimeSlot(TimeSlot? timeSlot) {
    final start = timeSlot?.start ?? '';
    final end = timeSlot?.end ?? '';
    if (start.isEmpty && end.isEmpty) return '';
    return '$start - $end';
  }
}
