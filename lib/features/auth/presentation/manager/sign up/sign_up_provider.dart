import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/auth/presentation/manager/sign%20up/sign_up_states.dart';

final signUpNotifierProvider =
    StateNotifierProvider<SignUpProvider, SignUpStates>(
  (ref) => SignUpProvider(
    SignUpStates(),
    ref,
    getIt<AuthRepository>(),
  ),
);

class SignUpProvider extends StateNotifier<SignUpStates> {
  SignUpProvider(
    super.state,
    this.ref,
    this.authRepo,
  );

  final Ref ref;
  final AuthRepository authRepo;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    final result = await authRepo.signUp(
        name: name, email: email, password: password, cityId: state.cityId!);

    result.when(
      sucess: (_) {
        state = state.copyWith(
          isLoading: false,
          isSignedUp: true,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );
  }

  Future<void> getCities() async {
    state = state.copyWith(isCitiesLoading: true);

    final result = await authRepo.getCities();

    result.when(
      sucess: (cities) {
        state = state.copyWith(isCitiesLoading: false, cities: cities);
      },
      failure: (error) {
        state =
            state.copyWith(isCitiesLoading: false, errorMessage: error.message);
      },
    );
  }

  void onCityChanged(int? cityId) {
    state = state.copyWith(cityId: cityId);
  }
}
