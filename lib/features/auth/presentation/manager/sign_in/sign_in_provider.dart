import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/sign_in/sign_in_states.dart';

final signInNotifierProvider =
    StateNotifierProvider<SignInProvider, SignInStates>(
        (ref) => SignInProvider(SignInStates(), ref, getIt<AuthRepository>()));

class SignInProvider extends StateNotifier<SignInStates> {
  SignInProvider(super.state, this.ref, this.authRepo);
  final Ref ref;
  final AuthRepository authRepo;
  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await authRepo.signIn(email: email, password: password);
    result.when(sucess: (_) async {
      await SharedPrefsService.prefs.setInt(SharedPrefKeys.step, 2);
      state = state.copyWith(isLoggedIn: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }

  Future<void> nativeGoogleSignIn() async {
    state = state.copyWith(isGoogleLoading: true, errorMessage: null);
    final result = await authRepo.nativeGoogleSignIn();
    result.when(sucess: (_) async {
      await SharedPrefsService.prefs.setInt(SharedPrefKeys.step, 2);
      state = state.copyWith(isLoggedIn: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }
}
