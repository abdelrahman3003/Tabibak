class SignInStates {
  final bool isLoading;
  final bool isGoogleLoading;
  final String? errorMessage;
  final bool isLoggedIn;
  final bool isProfileCompleted;

  SignInStates({
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.errorMessage,
    this.isLoggedIn = false,
    this.isProfileCompleted = false,
  });

  SignInStates copyWith({
    bool? isLoading,
    bool? isGoogleLoading,
    String? errorMessage,
    bool? isLoggedIn,
    bool? isProfileCompleted,
  }) {
    return SignInStates(
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
