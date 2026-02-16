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
  }) {
    return RatingStates(
      isLoading: isLoading ?? false,
      isSuccess: isSuccess ?? false,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
