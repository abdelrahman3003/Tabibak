import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos_imp.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_provider/appointment_states.dart';

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
  List<AppointmentModel> allAppointments = [];
  final AppointmentsRepos appointmentsRepos;
  getAppointments() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await appointmentsRepos.getAppointments();
    result.when(
      sucess: (appointments) {
        // Sort: upcoming first by date, keep stable order.
        appointments.sort((a, b) =>
            (a.appointmentDate ?? '').compareTo(b.appointmentDate ?? ''));
        allAppointments = appointments;
        // Re-apply active filter so refresh keeps the selected tab.
        final filtered = _applyFilter(appointments, state.selectedFilter);
        state = state.copyWith(
          appointments: filtered,
          clearError: true,
        );
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  /// Status codes (DB truth): 1 pending, 2 confirmed → upcoming;
  /// 3 completed, 4 cancelled → previous.
  List<AppointmentModel> _applyFilter(
      List<AppointmentModel> source, int filterIndex) {
    return source.where((appointment) {
      if (filterIndex == 0) {
        return appointment.status == 1 || appointment.status == 2;
      } else {
        return appointment.status == 3 || appointment.status == 4;
      }
    }).toList();
  }

  filterAppointmentsByStatus(int statusToFilter) {
    // statusToFilter comes from UI as index+1 (1 upcoming, 2 previous).
    final filterIndex = statusToFilter - 1;
    final filtered = _applyFilter(allAppointments, filterIndex);
    state = state.copyWith(
      appointments: filtered,
      selectedFilter: filterIndex,
      clearError: true,
    );
  }
}
