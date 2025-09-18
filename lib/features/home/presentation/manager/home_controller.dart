import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/data/repo/home_repo_imp.dart';
import 'package:tabibak/features/home/presentation/manager/home_states.dart';
import 'package:tabibak/gen/assets.gen.dart';

final categoryListNameProvider = StateProvider<List<String>>((ref) {
  return [
    StringConstants.general.tr(),
    StringConstants.urology.tr(),
    StringConstants.neurology.tr(),
    StringConstants.pediatrics.tr(),
    StringConstants.dentistry.tr(),
    StringConstants.optometry.tr(),
  ];
});
final categoryListIconsProvider = StateProvider<List<String>>((ref) {
  return [
    Assets.images.manDoctor.path,
    Assets.images.kidneys1.path,
    Assets.images.brain1.path,
    Assets.images.iamge.path,
    Assets.images.dentistry.path,
    Assets.images.optometry.path
  ];
});
final homrepoProvider = StateProvider<HomeRepo>(
  (ref) => HomeRepoImp(homeRemoteData: HomeRemoteData()),
);
final homeControllerPrvider =
    StateNotifierProvider.autoDispose<HomeController, HomeStates>(
        (ref) => HomeController(ref));
final buttonLoadingProvider = StateProvider<bool>((ref) => false);

class HomeController extends StateNotifier<HomeStates> {
  HomeController(this.ref) : super(HomeStates()) {
    initData();
  }
  final Ref ref;
  late TextEditingController commentController;
  void initData() async {
    await getUserById();
    await getAllDoctorsSummary();
    await fetchSpecialties();
  }

  Future<void> getDoctorData(int doctorId) async {
    await getDoctorById(doctorId);

    commentController = TextEditingController();
  }

  Future<void> fetchSpecialties() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homrepoProvider).fetchSpecialties();
    result.when(
      sucess: (data) {
        state = state.copyWith(specialties: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> getUserById() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homrepoProvider).getUserData();
    result.when(
      sucess: (data) {
        state = state.copyWith(userModel: data);
        ();
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> getAllDoctors() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homrepoProvider).fetchAllDoctors();
    result.when(
      sucess: (data) {
        state = state.copyWith(doctorsModelList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> getAllDoctorsSummary() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homrepoProvider).getAllDoctorsSummary();
    result.when(
      sucess: (data) {
        state = state.copyWith(doctorsSummaryList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> getDoctorById(int id) async {
    state = state.copyWith(isLoading: true);

    final result = await ref.read(homrepoProvider).getDoctorId(id);
    result.when(
      sucess: (data) {
        final avgRate = _avgRating(data);

        final doctorModel = data.copyWith(avgRate: avgRate);
        state = state.copyWith(doctorModel: doctorModel);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
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

  Future<void> getAllDoctorsSpecialties(int specialtyId) async {
    state = state.copyWith(isLoading: true);
    final result =
        await ref.read(homrepoProvider).getAllDoctorsSpecialties(specialtyId);
    result.when(
      sucess: (data) {
        state = state.copyWith(doctorsSpecialityList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
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
    state = state.copyWith(isSendCommentLoading: true);
    final result = await ref
        .read(homrepoProvider)
        .addComment(comment: commentController.text, doctorId: doctorId);

    result.when(
      sucess: (data) async {
        getDoctorComments(doctorId, false);
        state = state.copyWith(isSendCommentLoading: false);
        commentController.clear();
      },
      failure: (apiErrorModel) {
        state = state.copyWith(isSendCommentLoading: false);

        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> addRate(double rate, int doctorId) async {
    final result =
        await ref.read(homrepoProvider).addRate(rate: rate, doctorId: 3);

    result.when(
      sucess: (_) async {},
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
