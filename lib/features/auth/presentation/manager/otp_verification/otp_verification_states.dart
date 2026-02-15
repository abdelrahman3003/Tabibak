class OtpVerificationStates {
  final bool isLoading;
  final bool isSendingOtp;
  final String? errorMessage;
  final bool isVerifiedIn;
  final bool isSignedUp;

  OtpVerificationStates({
    this.isLoading = false,
    this.isSendingOtp = false,
    this.errorMessage,
    this.isVerifiedIn = false,
    this.isSignedUp = false,
  });
  OtpVerificationStates copyWith({
    bool? isLoading,
    bool? isSendingOtp,
    String? errorMessage,
    bool? isVerifiedIn,
    bool? isSignedUp,
  }) {
    return OtpVerificationStates(
      isLoading: isLoading ?? false,
      isSendingOtp: isSendingOtp ?? false,
      isVerifiedIn: isVerifiedIn ?? false,
      isSignedUp: isSignedUp ?? false,
      errorMessage: errorMessage,
    );
  }
}
