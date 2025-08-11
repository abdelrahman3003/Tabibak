import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/routes.dart';
import 'package:tabibak/core/services/shared_pref_service.dart';
import 'package:tabibak/features/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak/features/auth/domain/repo/auth_repo.dart';
import 'package:tabibak/features/auth/domain/repo/auth_repo_implement.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_states.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStates>(
        (ref) => AuthController(ref));
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthRemoteDatasource());
});
final emailConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());
final passordConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());
final nameConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());
final otpController =
    Provider<TextEditingController>((ref) => TextEditingController());
final newPasswordConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());
final confirmNewPasswordConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());
final resetPasswordKeyForm = Provider<GlobalKey<FormState>>(
  (ref) => GlobalKey<FormState>(),
);

class AuthController extends StateNotifier<AuthStates> {
  final Ref ref;

  AuthController(this.ref) : super(AuthInitial());

  Future<void> singUp(BuildContext context) async {
    state = SignUpLoading();
    final result = await ref.read(authRepositoryProvider).signUp(
          name: ref.read(nameConrtollerprovider).text,
          email: ref.read(emailConrtollerprovider).text,
          password: ref.read(passordConrtollerprovider).text,
        );
    result.when(sucess: (_) {
      context.pop();
      context.pushNamed(Routes.singinView);
      state = SignUpSuccess();
      cleartextformData();
    }, failure: (error) {
      state = SignUpSuccess();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }

  void cleartextformData() {
    ref.read(nameConrtollerprovider).clear();
    ref.read(emailConrtollerprovider).clear();
    ref.read(passordConrtollerprovider).clear();
  }

  Future<void> login(BuildContext context) async {
    state = LoginLoading();
    final result = await ref.read(authRepositoryProvider).login(
        email: ref.read(emailConrtollerprovider).text,
        password: ref.read(passordConrtollerprovider).text);
    result.when(sucess: (_) async {
      await SharedPrefsService.prefs.setInt(SharedPrefKeys.step, 1);

      context.pop();
      context.pushNamed(Routes.layoutScreen);
      cleartextformData();
      state = LoginSuccess();
    }, failure: (error) {
      state = LoginFailure();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }

  Future<void> sendOtp(BuildContext context) async {
    state = SendOtpLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .sendOpt(email: ref.read(emailConrtollerprovider).text);
    result.when(sucess: (_) async {
      final currentRoute = ModalRoute.of(context)?.settings.name;

      if (currentRoute != Routes.oTPVerificationScreen) {
        context.pushNamed(
          Routes.oTPVerificationScreen,
          arguments: ref.read(emailConrtollerprovider).text,
        );
      }
      state = SendOtpSuccess();
    }, failure: (error) {
      state = SendOtpSuccess();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }

  Future<void> verifyOtpCode(BuildContext context) async {
    state = VerifyOtpLoading();
    final result = await ref.read(authRepositoryProvider).verifyOtpCode(
          email: ref.read(emailConrtollerprovider).text,
          token: ref.read(otpController).text,
        );
    result.when(sucess: (_) async {
      context.pushNamed(Routes.resetPasswordView);
      state = VerifyOtpSuccess();
    }, failure: (error) {
      state = VerifyOtpFailure();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }

  Future<void> resetPassword(BuildContext context) async {
    state = ResetPassordLoading();
    final result = await ref.read(authRepositoryProvider).resetPassword(
          newPassword: ref.read(newPasswordConrtollerprovider).text,
        );
    result.when(sucess: (_) async {
      context.pushNamed(Routes.resetPasswordSucessView);
      state = ResetPassordSuccess();
    }, failure: (error) {
      state = ResetPassordFailure();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }
}
