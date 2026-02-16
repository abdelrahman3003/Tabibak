import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart'
    show DoctorRepo;
import 'package:tabibak/features/doctor/presentation/manager/doctor/doctor_provider.dart';
import 'package:tabibak/features/doctor/presentation/manager/rating/rating_states.dart';

final doctorRepoProvider = StateProvider<DoctorRepo>(
  (ref) => getIt<DoctorRepo>(),
);
final ratingNotifierProvider =
    StateNotifierProvider.autoDispose<RatingProvider, RatingStates>(
  (ref) => RatingProvider(ref),
);

class RatingProvider extends StateNotifier<RatingStates> {
  RatingProvider(this.ref) : super(RatingStates());
  final Ref ref;
  Future<void> addRate({required double rate}) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(doctorRepoProvider)
        .addRate(rate: rate, doctorId: ref.read(doctorIdProvider)!);
    result.when(
      sucess: (doctor) {
        state = state.copyWith(isSuccess: true);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
            errorMessage: apiErrorModel.errors, isSuccess: false);
      },
    );
  }
}
