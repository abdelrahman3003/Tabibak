import 'package:tabibak/features/appointment/data/model/appointment_model.dart';

class AppointmentDetailsStates {
  final bool isLoading;
  final bool isDeleting;
  final String? errorMessage;
  final bool isDeleted;
  final AppointmentModel? appointment;

  AppointmentDetailsStates({
    this.isLoading = false,
    this.isDeleting = false,
    this.errorMessage,
    this.isDeleted = false,
    this.appointment,
  });

  AppointmentDetailsStates copyWith({
    bool? isLoading,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
    bool? isDeleted,
    AppointmentModel? appointment,
  }) {
    return AppointmentDetailsStates(
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isDeleted: isDeleted ?? this.isDeleted,
      appointment: appointment ?? this.appointment,
    );
  }
}
