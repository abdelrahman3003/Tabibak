import 'package:tabibak/features/appointment/data/model/appointment_model.dart';

class AppointmentStates {
  final List<AppointmentModel>? appointments;
  final bool isLoading;
  final String? errorMessage;
  final int selectedFilter; // 0 = upcoming, 1 = previous

  AppointmentStates({
    this.appointments,
    this.isLoading = false,
    this.errorMessage,
    this.selectedFilter = 0,
  });
  AppointmentStates copyWith({
    final List<AppointmentModel>? appointments,
    final bool? isLoading,
    final String? errorMessage,
    final bool clearError = false,
    final int? selectedFilter,
  }) {
    return AppointmentStates(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? false,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
