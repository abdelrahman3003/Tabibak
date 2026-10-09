import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/doctor/presentation/manager/comment/comment_provider.dart';
import 'package:tabibak/features/doctor/presentation/manager/doctor/doctor_states.dart';

final doctorIdProvider = StateProvider<String?>((ref) => null);
final doctorRepoProvider = StateProvider<DoctorRepo>(
  (ref) => getIt<DoctorRepo>(),
);

final doctorNotifierProvider =
    StateNotifierProvider.autoDispose<DoctorProvider, DoctorStates>(
  (ref) {
    final provider = DoctorProvider(ref);
    final doctorId = ref.watch(doctorIdProvider);
    if (doctorId != null) {
      // Use microtask to avoid updating state during initialization
      Future.microtask(() => provider.getDoctor(doctorId));
    }
    return provider;
  },
);

class DoctorProvider extends StateNotifier<DoctorStates> {
  DoctorProvider(this.ref) : super(DoctorStates());
  
  final Ref ref;
  Future<void> getDoctor(String doctorId) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(doctorRepoProvider).getDoctor(doctorId);
    result.when(
      sucess: (doctor) {
        state = state.copyWith(doctorModel: doctor);
        ref.read(commentNotifierProvider.notifier).init(doctor.comments ?? []);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
            errorMessage: apiErrorModel.errors, isLoading: false);
      },
    );
  }
}
