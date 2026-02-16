import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/forget_password/forget_password_states.dart';

final forgetPasswordNotifierProvider =
    StateNotifierProvider<ForgetPasswordProvider, ForgetPasswordStates>((ref) =>
        ForgetPasswordProvider(
            ForgetPasswordStates(), ref, getIt<AuthRepository>()));

class ForgetPasswordProvider extends StateNotifier<ForgetPasswordStates> {
  ForgetPasswordProvider(super.state, this.ref, this.authRepo);

  final Ref ref;
  final AuthRepository authRepo;
  Future<void> sendOtp({required String email}) async {
    state = state.copyWith(isLoading: true);
    final result = await authRepo.sendOtp(email: email);
    result.when(sucess: (_) async {
      state = state.copyWith(isOTPSended: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }
}
