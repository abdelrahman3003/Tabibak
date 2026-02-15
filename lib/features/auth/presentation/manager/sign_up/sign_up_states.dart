class SignUpStates {
  final bool isLoading;
  final bool isSignedUp;
  final String? errorMessage;

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
