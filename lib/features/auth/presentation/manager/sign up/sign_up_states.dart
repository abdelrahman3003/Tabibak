class SignUpStates {
  final bool isLoading;
  final String? errorMessage;
  final bool isSignedUp;
  final int? specialtyId;

  SignUpStates({
    this.isLoading = false,
    this.errorMessage,
    this.isSignedUp = false,
    this.specialtyId,
  });
  SignUpStates copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSignedUp,
    int? specialtyId,
  }) {
    return SignUpStates(
      isLoading: isLoading ?? false,
      isSignedUp: isSignedUp ?? false,
      errorMessage: errorMessage,
      specialtyId: specialtyId ?? this.specialtyId,
    );
  }
}
