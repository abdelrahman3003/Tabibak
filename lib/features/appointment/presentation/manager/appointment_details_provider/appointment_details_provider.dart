import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/features/appointment/data/remote_data/appointments_remote_data.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos.dart';
import 'package:tabibak/features/appointment/data/repos/appointments_repos_imp.dart';
import 'package:tabibak/features/appointment/presentation/manager/appointment_details_provider/appointment_details_states.dart';

final appointmentDetailsNotifier = StateNotifierProvider.autoDispose<
    AppointmentDetailsProvider, AppointmentDetailsStates>(
  (ref) => AppointmentDetailsProvider(
    ref,
    AppointmentsReposImp(
      appointmentsRemoteData: AppointmentsRemoteData(
        supabase: Supabase.instance,
      ),
    ),
  ),
);

class AppointmentDetailsProvider
    extends StateNotifier<AppointmentDetailsStates> {
  AppointmentDetailsProvider(
    this.ref,
    this.appointmentsRepos,
  ) : super(AppointmentDetailsStates());

  final Ref ref;
  final AppointmentsRepos appointmentsRepos;

  Future<void> getAppointmentDetails(
    int appointmentId,
  ) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    final result = await appointmentsRepos.getAppointmentDetails(
      appointmentId,
    );

    result.when(
      sucess: (appointment) {
        state = state.copyWith(
          isLoading: false,
          appointment: appointment,
        );
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: apiErrorModel.errors,
        );
      },
    );
  }

  Future<void> deleteAppointment(
    int appointmentId,
  ) async {
    state = state.copyWith(
      isDeleting: true,
      clearError: true,
    );

    final result = await appointmentsRepos.deleteAppointment(
      appointmentId,
    );

    result.when(
      sucess: (data) {
        state = state.copyWith(
          isDeleting: false,
          isDeleted: true,
        );
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
          isDeleting: false,
          errorMessage: apiErrorModel.errors,
        );
      },
    );
  }

  void consumeDeleted() {
    state = state.copyWith(
      isDeleted: false,
      clearError: true,
    );
  }
}
