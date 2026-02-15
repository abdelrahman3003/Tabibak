import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/sign%20up/sign_up_states.dart';

final signUpNotifierProvider =
    StateNotifierProvider<SignUpProvider, SignUpStates>(
        (ref) => SignUpProvider(SignUpStates(), ref, getIt<AuthRepository>()));

class SignUpProvider extends StateNotifier<SignUpStates> {
  SignUpProvider(super.state, this.ref, this.authRepo);
  final Ref ref;
  final AuthRepository authRepo;
  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result =
        await authRepo.signUp(name: name, email: email, password: password);
    result.when(sucess: (_) async {
      state = state.copyWith(isSignedUp: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
    });
  }
}
