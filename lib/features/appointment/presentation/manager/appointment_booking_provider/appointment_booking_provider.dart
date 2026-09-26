import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_booking_provider/appointment_booking_states.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_provider/appointment_provider.dart';

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
    state = state.copyWith(
      isShiftLoading: true,
      clearError: true,
      clearEmptyShift: true,
    );
    final result =
        await appointmentsRepos.getDayShift(dayEn: dayEn, clinicId: clinicId);
    result.when(
      sucess: (dayShiftsModel) {
        if (dayShiftsModel?.evening == null &&
            dayShiftsModel?.morning == null) {
          state = state.copyWith(
            isShiftLoading: false,
            emptyShift: AppStrings.thisDayNotAvailable,
            clearDayShifts: true,
            clearError: true,
          );
        } else {
          state = state.copyWith(
            isShiftLoading: false,
            dayShiftsModel: dayShiftsModel,
            clearEmptyShift: true,
            clearError: true,
          );
        }
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
          isShiftLoading: false,
          errorMessage: apiErrorModel.errors,
          clearDayShifts: true,
        );
      },
    );
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    if (appointment.shiftMorningId == null &&
        appointment.shiftEveningId == null) {
      state = state.copyWith(
        errorMessage: 'Please select a period (morning/evening)',
      );
      return;
    }
    state = state.copyWith(
      isLoading: true,
      appointmentModel: appointment,
      clearError: true,
    );
    final result = await appointmentsRepos.addAppointment(appointment);

    result.when(
      sucess: (commentList) {
        ref.invalidate(appointsProviderNotifier);
        state = state.copyWith(isLoading: false, isSuccess: true);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: apiErrorModel.errors,
        );
      },
    );
  }

  void consumeSuccess() {
    state = state.copyWith(clearAppointment: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
