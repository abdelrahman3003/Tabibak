import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
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
  String? otp;

  Future<void> verifyOtpCode(
      {required UserModel userModel, bool isSignUp = false}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result =
        await authRepo.verifyOtpCode(userModel: userModel, otp: otp ?? "");
    result.when(sucess: (_) async {
      state = state.copyWith(isVerifiedIn: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }
}
