class ForgetPasswordStates {
  final bool isLoading;
  final bool isOTPSended;
  final String? errorMessage;

  ForgetPasswordStates(
      {this.isLoading = false, this.isOTPSended = false, this.errorMessage});
  ForgetPasswordStates copyWith({
    bool? isLoading,
    bool? isOTPSended,
    String? errorMessage,
  }) {
    return ForgetPasswordStates(
        isLoading: isLoading ?? false,
        isOTPSended: isOTPSended ?? false,
        errorMessage: errorMessage);
  }
}
