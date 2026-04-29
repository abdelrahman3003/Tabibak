import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_states.dart';

final appointmentBookingNotifierProvider = StateNotifierProvider.autoDispose<
    AppointmentBookingProvider, AppointmentBookingStates>(
  (ref) => AppointmentBookingProvider(ref, getIt<AppointmentsRepos>()),
);

class AppointmentBookingProvider
    extends StateNotifier<AppointmentBookingStates> {
  AppointmentBookingProvider(this.ref, this.appointmentsRepos)
      : super(AppointmentBookingStates());

  final Ref ref;
  final AppointmentsRepos appointmentsRepos;
  Future<void> getSHift({required String dayEn, required int clinicId}) async {
    state = state.copyWith(isLoading: true);
    final result =
        await appointmentsRepos.getDayShift(dayEn: dayEn, clinicId: clinicId);
    result.when(
      sucess: (dayShiftsModel) {
        if (dayShiftsModel?.evening == null &&
            dayShiftsModel?.morning == null) {
          state = state.copyWith(
            emptyShift: AppStrings.thisDayNotAvailable,
            clearDayShifts: true, // ✅ actually clears old model
          );
        } else {
          state = state.copyWith(
            dayShiftsModel: dayShiftsModel,
            emptyShift: null,
          );
        }
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
          errorMessage: apiErrorModel.errors,
          clearDayShifts: true, // ✅ clear stale shifts on error too
        );
      },
    );
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    log("--------- shift provider  ---- ${appointment.shiftMorningId}");

    state = state.copyWith(isLoading: true, appointmentModel: appointment);
    final result = await appointmentsRepos.addAppointment(appointment);

    result.when(
      sucess: (commentList) {
        state = state.copyWith(isSuccess: true);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
