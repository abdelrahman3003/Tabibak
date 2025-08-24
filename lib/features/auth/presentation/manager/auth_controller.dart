import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/services/shared_pref_service.dart';
import 'package:tabibak/core/utls/extention.dart';
import 'package:tabibak/core/utls/routes.dart';
import 'package:tabibak/features/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo_implement.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthStates>(
        (ref) => AuthController(ref));
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthRemoteDatasource());
});

class AuthController extends StateNotifier<AuthStates> {
  final Ref ref;

  AuthController(this.ref) : super(AuthInitial());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final resetPasswordKeyForm = GlobalKey<FormState>();
  final sendOtpKey = GlobalKey<FormState>();
  Future<void> singUp(BuildContext context) async {
    state = SignUpLoading();
    final result = await ref.read(authRepositoryProvider).signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text);

    result.when(sucess: (_) async {
      context.pop();
      context.pushNamed(Routes.singinView);
      cleartextformData();
      state = SignUpSuccess();
    }, failure: (error) {
      state = SignUpSuccess();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }

  Future<void> login(BuildContext context) async {
    state = LoginLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .login(email: emailController.text, password: passwordController.text);
    result.when(sucess: (_) async {
      context.pop();
      context.pushNamed(Routes.layoutScreen);
      await SharedPrefsService.prefs.setInt(SharedPrefKeys.step, 1);

      cleartextformData();
      state = LoginSuccess();
    }, failure: (error) {
      state = LoginFailure();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }

  Future<void> nativeGoogleSignIn(BuildContext context) async {
    state = LoginWithGoogleLoading();
    final result = await ref.read(authRepositoryProvider).nativeGoogleSignIn();
    result.when(sucess: (_) async {
      context.pop();
      context.pushNamedAndRemoveUntil(Routes.layoutScreen,
          predicate: (route) => false);
      await SharedPrefsService.prefs.setInt(SharedPrefKeys.step, 1);

      cleartextformData();
      state = LoginWithGoogleSuccess();
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
        .sendOpt(email: emailController.text);
    result.when(sucess: (_) async {
      final currentRoute = ModalRoute.of(context)?.settings.name;

      if (currentRoute != Routes.oTPVerificationScreen) {
        context.pushNamed(
          Routes.oTPVerificationScreen,
          arguments: emailController.text,
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
          email: emailController.text,
          token: otpController.text,
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
          newPassword: newPasswordController.text,
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

  // Future<void> addUserData() async {
  //   final currentUserId = Supabase.instance.client.auth.currentUser!.id;
  //   state = AddUserDataLoading();
  //   final result = await ref.read(authRepositoryProvider).addUserData(UserModel(
  //       userId: currentUserId,
  //       name: nameController.text,
  //       email: emailController.text));
  //   result.when(sucess: (_) async {
  //     state = AddUserDataSuceess();
  //   }, failure: (error) {
  //     state = AddUserDataFailure();
  //   });
  // }

  void cleartextformData() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }
}
