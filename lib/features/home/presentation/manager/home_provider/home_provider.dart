import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/doctor_details/presentaion/manager/doctor_details_provider.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/data/repo/home_repo_imp.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_states.dart';
import 'package:tabibak/gen/assets.gen.dart';

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
final homeRepoProvider = StateProvider<HomeRepo>(
  (ref) => HomeRepoImp(homeRemoteData: HomeRemoteData()),
);
final buttonLoadingProvider = StateProvider<bool>((ref) => false);

final homeControllerProvider =
    StateNotifierProvider.autoDispose<HomeController, HomeStates>(
        (ref) => HomeController(ref));

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

  Future<void> fetchSpecialties() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homeRepoProvider).fetchSpecialties();
    result.when(
      sucess: (data) {
        state = state.copyWith(specialties: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  goToDoctorDetails(BuildContext context, int id) async {
    context.pushNamed(Routes.doctorDetailsScreen);

    await ref.watch(doctorDetailsNotifierProvider.notifier).getDoctorById(id);
  }

  Future<void> getUserById() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homeRepoProvider).getUserData();
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
    final result = await ref.read(homeRepoProvider).fetchAllDoctors();
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
    final result = await ref.read(homeRepoProvider).getAllDoctorsSummary();
    result.when(
      sucess: (data) {
        state = state.copyWith(doctorsSummaryList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> getAllDoctorsSpecialties(int specialtyId) async {
    state = state.copyWith(isLoading: true);
    final result =
        await ref.read(homeRepoProvider).getAllDoctorsSpecialties(specialtyId);
    result.when(
      sucess: (data) {
        state = state.copyWith(doctorsSpecialtyList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }

  Future<void> addRate(double rate, int doctorId) async {
    final result =
        await ref.read(homeRepoProvider).addRate(rate: rate, doctorId: 3);

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
