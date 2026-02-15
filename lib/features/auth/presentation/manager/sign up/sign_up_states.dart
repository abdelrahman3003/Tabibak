class SignUpStates {
  final bool isLoading;
  final String? errorMessage;
  final bool isSignedUp;

  SignUpStates({
    this.isLoading = false,
    this.errorMessage,
    this.isSignedUp = false,
  });
  SignUpStates copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSignedUp,
  }) {
    return SignUpStates(
      isLoading: isLoading ?? false,
      isSignedUp: isSignedUp ?? false,
      errorMessage: errorMessage,
    );
  }
}
