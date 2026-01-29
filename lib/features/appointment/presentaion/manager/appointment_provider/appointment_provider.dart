import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos_imp.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_provider/appointment_states.dart';

final appointsProviderNotifier =
    StateNotifierProvider.autoDispose<AppointmentProvider, AppointmentStates>(
  (ref) => AppointmentProvider(
      ref,
      AppointmentsReposImp(
          appointmentsRemoteData:
              AppointmentsRemoteData(supabase: Supabase.instance))),
);

final class AppointmentProvider extends StateNotifier<AppointmentStates> {
  AppointmentProvider(this.ref, this.appointmentsRepos)
      : super(AppointmentStates()) {
    getAppointments();
  }

  final Ref ref;
  final AppointmentsRepos appointmentsRepos;
  getAppointments() async {
    state = state.copyWith(isLoading: true);
    final result = await appointmentsRepos.getAppointments();
    result.when(
      sucess: (appointments) {
        state = state.copyWith(appointments: appointments);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
