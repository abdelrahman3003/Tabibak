import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/doctor/data/remote_data/doctor_remote_data.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo.dart';
import 'package:tabibak/features/doctor/data/repo/doctor_repo_impl.dart';
import 'package:tabibak/features/doctor/presentaion/manager/doctor_states.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';

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

  // num _avgRating(DoctorModel doctorModel) {
  //   final ratings =
  //       doctorModel.ratings?.map((e) => e.rate.toDouble()).toList() ?? [];
  //   if (ratings.isEmpty) return 0;
  //   final avgRate = ratings.reduce((a, b) => a + b) / ratings.length;
  //   return avgRate;
  // }

  Future<void> getDoctorComments(int doctorid, bool isLoadin) async {
    state = state.copyWith(isLoading: isLoadin);
    final result = await ref.read(homeRepoProvider).getDoctorComments(doctorid);
    result.when(
      sucess: (data) {
        state = state.copyWith(doctorCommentModelList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> addComment(int doctorId) async {
    state = state.copyWith(isLoading: true);
    final result = await ref
        .read(homeRepoProvider)
        .addComment(comment: commentTextController.text, doctorId: doctorId);

    result.when(
      sucess: (data) async {
        getDoctorComments(doctorId, false);
        state = state.copyWith(isLoading: false);
        commentTextController.clear();
      },
      failure: (apiErrorModel) {
        state = state.copyWith(isLoading: false);

        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
