import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/specialty_doctors_states.dart';

final specialtyDoctorsProvider =
    StateNotifierProvider<SpecialtyDoctorsNotifier, SpecialtyDoctorsStates>(
  (ref) => SpecialtyDoctorsNotifier(ref),
);

class SpecialtyDoctorsNotifier extends StateNotifier<SpecialtyDoctorsStates> {
  SpecialtyDoctorsNotifier(this.ref) : super(SpecialtyDoctorsStates());
  final Ref ref;
  Future<void> getSpecialtiesDoctors(int specialtyId) async {
    state = state.copyWith(isLoading: true);
    final result =
        await ref.read(homeRepoProvider).getSpecialtiesDoctors(specialtyId);
    result.when(
      sucess: (specialtyDoctors) {
        state = state.copyWith(specialtyDoctors: specialtyDoctors);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
