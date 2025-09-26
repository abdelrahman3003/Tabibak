class AppointmentDetailsStates {
  final bool isLoading;

  AppointmentDetailsStates({this.isLoading = false});
  AppointmentDetailsStates copyWith({
    final bool? isLoading,
  }) {
    return AppointmentDetailsStates(isLoading: isLoading ?? this.isLoading);
  }
}
