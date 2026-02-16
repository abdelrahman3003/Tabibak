import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/reset_password/reset_password_states.dart';

final resetPasswordNotifierProvider =
    StateNotifierProvider<ResetPasswordProvider, ResetPasswordStates>((ref) =>
        ResetPasswordProvider(
            ResetPasswordStates(), ref, getIt<AuthRepository>()));

class ResetPasswordProvider extends StateNotifier<ResetPasswordStates> {
  ResetPasswordProvider(super.state, this.ref, this.authRepo);

  final Ref ref;
  final AuthRepository authRepo;
  Future<void> resetPassword({required String newPassword}) async {
    state = state.copyWith(isLoading: true);
    final result = await authRepo.resetPassword(newPassword: newPassword);
    result.when(sucess: (_) async {
      state = state.copyWith(isReset: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }
}
