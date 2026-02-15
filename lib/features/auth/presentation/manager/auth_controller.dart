import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthStates>(
        (ref) => AuthController(ref));
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

class AuthController extends StateNotifier<AuthStates> {
  final Ref ref;

  AuthController(this.ref) : super(AuthInitial());

  Future<void> resetPassword({required String newPassword}) async {
    state = ResetPasswordLoading();
    final result = await ref.read(authRepositoryProvider).resetPassword(
          newPassword: newPassword,
        );
    result.when(sucess: (_) async {
      state = ResetPasswordSuccess();
    }, failure: (error) {
      state = ResetPasswordFailure(error.message.toString());
    });
  }
}
