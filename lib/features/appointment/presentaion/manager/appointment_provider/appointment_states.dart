import 'package:tabibak/features/appointment/data/model/appointment_model.dart';

class AppointmentStates {
  final List<AppointmentModel>? appointments;
  final bool isLoading;
  final String? errorMessage;

  AppointmentStates({
    this.appointments,
    this.isLoading = false,
    this.errorMessage,
  });
  AppointmentStates copyWith({
    final List<AppointmentModel>? appointments,
    final bool? isLoading,
    final String? errorMessage,
  }) {
    return AppointmentStates(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? false,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
