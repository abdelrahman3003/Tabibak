import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos_imp.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_details_provider/appointment_details_states.dart';

final appointmentDetailsNotifier = StateNotifierProvider.autoDispose<
    AppointmentDetailsProvider, AppointmentDetailsStates>(
  (ref) => AppointmentDetailsProvider(
      ref,
      AppointmentsReposImp(
          appointmentsRemoteData:
              AppointmentsRemoteData(supabase: Supabase.instance))),
);

class AppointmentDetailsProvider
    extends StateNotifier<AppointmentDetailsStates> {
  AppointmentDetailsProvider(this.ref, this.appointmentsRepos)
      : super(AppointmentDetailsStates());
  final Ref ref;
  final AppointmentsRepos appointmentsRepos;
  deleteAppointment(int appointmentId) async {
    state = state.copyWith(isLoading: true);
    final result = await appointmentsRepos.deleteAppointment(appointmentId);
    result.when(
      sucess: (data) {
        state = state.copyWith(isDeleted: true);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
