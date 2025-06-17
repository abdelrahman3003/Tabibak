import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/class/naviagtion.dart';
import 'package:tabibak/core/class/routes.dart';
import 'package:tabibak/features/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak/features/auth/domain/repo/auth_repo.dart';
import 'package:tabibak/features/auth/domain/repo/auth_repo_implement.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_states.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStates>(
        (ref) => AuthController(ref));
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthRemoteDatasource());
});
final emailConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());
final passordConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());
final nameConrtollerprovider =
    Provider<TextEditingController>((ref) => TextEditingController());

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
    }, failure: (error) {
      state = SignUpSuccess();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }

  Future<void> login(BuildContext context) async {
    state = LoginLoading();
    final result = await ref.read(authRepositoryProvider).login(
        email: ref.read(emailConrtollerprovider).text,
        password: ref.read(passordConrtollerprovider).text);
    result.when(sucess: (_) {
      context.pop();
      context.pushNamed(Routes.singupView);
      state = LoginSuccess();
    }, failure: (error) {
      state = LoginFailure();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    });
  }
}
