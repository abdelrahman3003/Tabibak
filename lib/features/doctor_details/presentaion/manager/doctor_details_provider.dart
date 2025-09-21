import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/doctor_details/presentaion/manager/doctor_details_states.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/data/repo/home_repo_imp.dart';

final homrepoProvider = StateProvider<HomeRepo>(
  (ref) => HomeRepoImp(homeRemoteData: HomeRemoteData()),
);
final doctorDetailsNotifierProvider = StateNotifierProvider.autoDispose<
    DoctorDetailsController, DoctorDetailsStates>(
  (ref) => DoctorDetailsController(ref),
);

class DoctorDetailsController extends StateNotifier<DoctorDetailsStates> {
  DoctorDetailsController(this.ref) : super(DoctorDetailsStates());
  final Ref ref;
  final commentTextController = TextEditingController();
  Future<void> getDoctorById(int id) async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homrepoProvider).getDoctorId(id);
    state = state.copyWith(isLoading: false);

    result.when(
      sucess: (data) {
        final avgRate = _avgRating(data);
        final doctorModel = data.copyWith(avgRate: avgRate);
        state = state.copyWith(doctorModel: doctorModel, isLoading: false);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(
            errorMessage: apiErrorModel.errors, isLoading: false);
      },
    );
  }

  num _avgRating(DoctorModel doctorModel) {
    final ratings =
        doctorModel.ratings?.map((e) => e.rate.toDouble()).toList() ?? [];
    if (ratings.isEmpty) return 0;
    final avgRate = ratings.reduce((a, b) => a + b) / ratings.length;
    return avgRate;
  }

  Future<void> getDoctorComments(int doctorid, bool isLoadin) async {
    state = state.copyWith(isLoading: isLoadin);
    final result = await ref.read(homrepoProvider).getDoctorComments(doctorid);
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
        .read(homrepoProvider)
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
