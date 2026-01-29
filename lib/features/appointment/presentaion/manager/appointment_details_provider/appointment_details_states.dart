class AppointmentDetailsStates {
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleted;
  AppointmentDetailsStates({
    this.isLoading = false,
    this.errorMessage,
    this.isDeleted = false,
  });
  AppointmentDetailsStates copyWith({
    final bool? isLoading,
    final String? errorMessage,
    final bool? isDeleted,
  }) {
    return AppointmentDetailsStates(
      isLoading: isLoading ?? false,
      errorMessage: errorMessage,
      isDeleted: isDeleted ?? false,
    );
  }
}
