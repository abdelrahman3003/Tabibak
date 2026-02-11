import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart' show HomeRepo;
import 'package:tabibak/features/home/presentation/manager/all_specialteis_provider/all_specialties_states.dart';

final homeRepoProvider = StateProvider<HomeRepo>(
  (ref) => getIt<HomeRepo>(),
);
final specialtiesNotifierProvider = StateNotifierProvider.autoDispose<
    AllSpecialtiesProvider,
    AllSpecialtiesStates>((ref) => AllSpecialtiesProvider(ref));

class AllSpecialtiesProvider extends StateNotifier<AllSpecialtiesStates> {
  AllSpecialtiesProvider(this.ref) : super(AllSpecialtiesStates()) {
    getAllSpecialties();
  }
  final Ref ref;
  getAllSpecialties() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homeRepoProvider).getSpecialties();
    result.when(
      sucess: (data) {
        state = state.copyWith(specialties: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
