class OtpVerificationStates {
  final bool isLoading;
  final bool isSendingOtp;
  final String? errorMessage;
  final bool isVerifiedIn;

  OtpVerificationStates({
    this.isLoading = false,
    this.isSendingOtp = false,
    this.errorMessage,
    this.isVerifiedIn = false,
  });
  OtpVerificationStates copyWith({
    bool? isLoading,
    bool? isSendingOtp,
    String? errorMessage,
    bool? isVerifiedIn,
  }) {
    return OtpVerificationStates(
      isLoading: isLoading ?? false,
      isSendingOtp: isSendingOtp ?? false,
      isVerifiedIn: isVerifiedIn ?? false,
      errorMessage: errorMessage,
    );
  }
}
