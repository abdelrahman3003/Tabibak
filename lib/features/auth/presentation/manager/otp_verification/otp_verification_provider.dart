import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/otp_verification/otp_verification_states.dart';

final otpVerificationNotifierProvider =
    StateNotifierProvider<OtpVerificationProvider, OtpVerificationStates>(
        (ref) => OtpVerificationProvider(
            OtpVerificationStates(), ref, getIt<AuthRepository>()));

class OtpVerificationProvider extends StateNotifier<OtpVerificationStates> {
  OtpVerificationProvider(super.state, this.ref, this.authRepo);
  final Ref ref;
  final AuthRepository authRepo;
  Future<void> sendOtp({required String email}) async {
    state = state.copyWith(isSendingOtp: true, errorMessage: null);
    final result = await authRepo.sendOtp(email: email);
    result.when(sucess: (_) async {
      state = state.copyWith();
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }

  Future<void> verifyOtpCode(
      {required String email,
      required String otp,
      bool isSignUp = false}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await authRepo.verifyOtpCode(email: email, otp: otp);
    result.when(sucess: (_) async {
      state = state.copyWith(isVerifiedIn: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }
}
