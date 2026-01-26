import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/appointment/presentaion/manager/appointment_details_provider/appointment_details_states.dart';

final appointmentdetailsNotifer = StateNotifierProvider.autoDispose<
    AppointmentDetailsProvider, AppointmentDetailsStates>(
  (ref) => AppointmentDetailsProvider(ref),
);

class AppointmentDetailsProvider
    extends StateNotifier<AppointmentDetailsStates> {
  AppointmentDetailsProvider(this.ref) : super(AppointmentDetailsStates());
  final Ref ref;
}
