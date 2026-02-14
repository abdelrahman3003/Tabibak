import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/data/model/specialty_model.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/manager/specialty_doctors_provider/doctors_specialty_states.dart';

final specialtyProvider = StateProvider<SpecialtyModel?>((ref) => null);
final doctorsSpecialtyProvider =
    StateNotifierProvider<DoctorsSpecialtyProvider, SpecialtyDoctorsStates>(
  (ref) => DoctorsSpecialtyProvider(ref),
);

class DoctorsSpecialtyProvider extends StateNotifier<SpecialtyDoctorsStates> {
  DoctorsSpecialtyProvider(this.ref) : super(SpecialtyDoctorsStates());
  final Ref ref;
  Future<void> getSpecialtiesDoctors({int? specialtyId, String? sortBy}) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homeRepoProvider).getDoctorSpecialist(
        sortBy: sortBy,
        specialtyId: specialtyId ?? ref.read(specialtyProvider)!.id);

    result.when(
      sucess: (specialtyDoctors) {
        state = state.copyWith(specialtyDoctors: specialtyDoctors);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  void sortDoctorsByRating({bool ascending = false}) {
    state = state.copyWith(isLoading: true);

    state.specialtyDoctors?.sort((a, b) {
      int aRating = a.avrRating?.toInt() ?? 0;
      int bRating = b.avrRating?.toInt() ?? 0;

      return ascending
          ? aRating.compareTo(bRating)
          : bRating.compareTo(aRating);
    });
    state = state.copyWith(isLoading: false);
  }

  void sortDoctorsByFee({bool ascending = true}) {
    state = state.copyWith(isLoading: true);

    state.specialtyDoctors?.sort((a, b) {
      double aFee = (a.clinic?.consultationFee ?? double.infinity).toDouble();
      double bFee = (b.clinic?.consultationFee ?? double.infinity).toDouble();

      return ascending ? aFee.compareTo(bFee) : bFee.compareTo(aFee);
    });
    state = state.copyWith(isLoading: false);
  }
}
