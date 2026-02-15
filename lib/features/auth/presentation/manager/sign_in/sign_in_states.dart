class SignInStates {
  final bool isLoading;
  final bool isGoogleLoading;
  final String? errorMessage;
  final bool isLoggedIn;

  SignInStates({
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.errorMessage,
    this.isLoggedIn = false,
  });
  SignInStates copyWith({
    bool? isLoading,
    bool? isGoogleLoading,
    String? errorMessage,
    bool? isLoggedIn,
  }) {
    return SignInStates(
      isLoading: isLoading ?? false,
      isGoogleLoading: isGoogleLoading ?? false,
      isLoggedIn: isLoggedIn ?? false,
      errorMessage: errorMessage,
    );
  }
}
