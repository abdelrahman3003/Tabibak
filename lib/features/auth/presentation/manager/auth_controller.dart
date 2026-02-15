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

  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    state = SignUpLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signUp(name: name, email: email, password: password);

    result.when(sucess: (_) async {
      state = SignUpSuccess();
    }, failure: (error) {
      state = SignUpFailure(error.message.toString());
    });
  }

  Future<void> sendOtp({required String email}) async {
    state = SendOtpLoading();
    final result = await ref.read(authRepositoryProvider).sendOpt(email: email);
    result.when(sucess: (_) async {
      state = SendOtpSuccess();
    }, failure: (error) {
      state = SendOtpFailure(error.message.toString());
    });
  }

  Future<void> verifyOtpCode(
      {required String email,
      required String otp,
      bool isSignUp = false}) async {
    state = VerifyOtpLoading();
    final result = await ref.read(authRepositoryProvider).verifyOtpCode(
          email: email,
          token: otp,
        );
    result.when(sucess: (_) async {
      if (isSignUp) {
        state = VerifyOtpSuccess();
      } else {
        state = VerifyOtpSuccess();
      }
    }, failure: (error) {
      state = VerifyOtpFailure(error.message.toString());
    });
  }

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
