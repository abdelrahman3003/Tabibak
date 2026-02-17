class AppointmentDetailsStates {
  final bool isLoading;
  final bool isDeleting;

  final String? errorMessage;
  final bool isDeleted;
  final int? appointmentQueue;
  AppointmentDetailsStates(
      {this.isLoading = false,
      this.isDeleting = false,
      this.errorMessage,
      this.isDeleted = false,
      this.appointmentQueue});
  AppointmentDetailsStates copyWith({
    final bool? isLoading,
    final bool? isDeleting,
    final String? errorMessage,
    final bool? isDeleted,
    final int? appointmentQueue,
  }) {
    return AppointmentDetailsStates(
      isLoading: isLoading ?? false,
      isDeleting: isDeleting ?? false,
      errorMessage: errorMessage,
      isDeleted: isDeleted ?? false,
      appointmentQueue: appointmentQueue ?? this.appointmentQueue,
    );
  }
}
