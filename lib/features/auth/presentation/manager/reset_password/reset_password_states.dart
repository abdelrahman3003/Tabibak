class ResetPasswordStates {
  final bool isLoading;
  final bool isReset;
  final String? errorMessage;

  ResetPasswordStates(
      {this.isLoading = false, this.isReset = false, this.errorMessage});
  ResetPasswordStates copyWith({
    bool? isLoading,
    bool? isReset,
    String? errorMessage,
  }) {
    return ResetPasswordStates(
        isLoading: isLoading ?? false,
        isReset: isReset ?? false,
        errorMessage: errorMessage);
  }
}
