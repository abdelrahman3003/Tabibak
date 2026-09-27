class RatingStates {
  final bool isSuccess;
  final bool isLoading;
  final String? errorMessage;

  RatingStates({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });
  RatingStates copyWith({
    final bool? isSuccess,
    final bool? isLoading,
    final String? errorMessage,
    final bool clearError = false,
  }) {
    return RatingStates(
      isLoading: isLoading ?? false,
      isSuccess: isSuccess ?? false,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
