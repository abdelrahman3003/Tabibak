import 'package:tabibak/features/appointment/data/model/appointment_model.dart';

class AppointmentStates {
  final bool isLoading;
  final List<Appointment>? appointmentList;
  final List<AppointmentStatus>? appointmentStatesList;
  final String? errorMessage;

  AppointmentStates({
    this.isLoading = false,
    this.appointmentList,
    this.appointmentStatesList,
    this.errorMessage,
  });
  AppointmentStates copywith({
    bool? isLoading,
    List<Appointment>? appointmentList,
    List<AppointmentStatus>? appointmentStatesList,
    String? errorMessage,
  }) {
    return AppointmentStates(
        isLoading: isLoading ?? this.isLoading,
        appointmentList: appointmentList ?? this.appointmentList,
        appointmentStatesList:
            appointmentStatesList ?? this.appointmentStatesList,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
