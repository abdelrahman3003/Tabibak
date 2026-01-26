import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/doctor/data/remote_data/doctor_remote_data.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo_impl.dart';
import 'package:tabibak/features/doctor/presentaion/manager/doctor_states.dart';

final doctorIdProvider = StateProvider<String?>((ref) => null);
final doctorRepoProvider = StateProvider<DoctorRepo>(
  (ref) => DoctorRepoImpl(doctorRemoteData: DoctorRemoteData()),
);

final doctorNotifierProvider =
    StateNotifierProvider.autoDispose<DoctorProvider, DoctorStates>(
  (ref) => DoctorProvider(ref),
);

class DoctorProvider extends StateNotifier<DoctorStates> {
  DoctorProvider(this.ref) : super(DoctorStates()) {
    getDoctor(ref.read(doctorIdProvider.notifier).state!);
  }
  final Ref ref;
  final commentTextController = TextEditingController();
  Future<void> getDoctor(String doctorId) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(doctorRepoProvider).getDoctor(doctorId);

    result.when(
      sucess: (doctor) {
        state = state.copyWith(doctorModel: doctor);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
            errorMessage: apiErrorModel.errors, isLoading: false);
      },
    );
  }

  Future<void> addComment(int doctorId) async {
    state = state.copyWith(isLoading: true);
  }
}
