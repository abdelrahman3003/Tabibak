import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_details_provider/appointment_details_states.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_provider/appointment_provider.dart';

final appointmentdetailsNotifer = StateNotifierProvider.autoDispose<
    AppointmentDetailsProvider, AppointmentDetailsStates>(
  (ref) => AppointmentDetailsProvider(ref),
);

class AppointmentDetailsProvider
    extends StateNotifier<AppointmentDetailsStates> {
  AppointmentDetailsProvider(this.ref) : super(AppointmentDetailsStates());
  final Ref ref;
  deleteAppointment(BuildContext context, int appointmentId) async {
    state = state.copyWith(isLoading: true);
    final result =
        await ref.read(appointmentsRepos).deleteAppointment(appointmentId);
    result.when(
      sucess: (data) async {
        state = state.copyWith(isLoading: false);
        ref.read(appointmentProviderNotifer.notifier).getAllAppoinments();
        context.pop();
      },
      failure: (apiErrorModel) {},
    );
  }
}
