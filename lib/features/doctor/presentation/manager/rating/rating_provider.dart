import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart'
    show DoctorRepo;
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
  Future<void> addRate({
    required int rate,
    required String doctorId,
    required String? review,
  }) async {
    state = RatingStates(isLoading: true);
    final result = await ref.read(doctorRepoProvider).addRate(
          rate: rate,
          doctorId: doctorId,
          review: review,
        );
    result.when(
      sucess: (doctor) {
        state = state.copyWith(isSuccess: true);
      },
      failure: (apiErrorModel) {
        state = RatingStates(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
