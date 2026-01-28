import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos_imp.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_booking_provider/appointment_booking_states.dart';

final appointmentBookingNotifierProvider = StateNotifierProvider.autoDispose<
    AppointmentBookingProvider, AppointmentBookingStates>(
  (ref) => AppointmentBookingProvider(
      ref,
      AppointmentsReposImp(
          appointmentsRemoteData:
              AppointmentsRemoteData(supabase: Supabase.instance))),
);

class AppointmentBookingProvider
    extends StateNotifier<AppointmentBookingStates> {
  AppointmentBookingProvider(this.ref, this.appointmentsRepos)
      : super(AppointmentBookingStates());

  final Ref ref;
  final AppointmentsRepos appointmentsRepos;
  Future<void> getSHift({required String dayEn, required int clinicId}) async {
    state = state.copyWith(isShiftLoading: true);
    final result =
        await appointmentsRepos.getDayShift(dayEn: dayEn, clinicId: clinicId);
    result.when(
      sucess: (dayShiftsModel) {
        state = state.copyWith(dayShiftsModel: dayShiftsModel);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    state = state.copyWith(isLoading: true);
    final result = await appointmentsRepos.addAppointment(appointment);

    result.when(
      sucess: (commentList) {
        state = state.copyWith();
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
