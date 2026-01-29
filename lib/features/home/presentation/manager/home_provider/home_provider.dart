import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/repo/home_repo.dart';
import 'package:tabibak/features/home/data/repo/home_repo_imp.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_states.dart';

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
  void initData() async {
    await getUserById();
    await getSpecialties();
    await getTopDoctors();
  }

  Future<void> getSpecialties() async {
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

  Future<void> getTopDoctors() async {
    state = state.copyWith(isLoading: true);
    final result = await ref.read(homeRepoProvider).geTopDoctors();
    result.when(
      sucess: (doctorsLList) {
        state = state.copyWith(topDoctorsList: doctorsLList);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
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

  Future<void> getDoctorSpecialist(int specialtyId) async {
    state = state.copyWith(isLoading: true);
    final result =
        await ref.read(homeRepoProvider).getDoctorSpecialist(specialtyId);
    result.when(
      sucess: (data) {
        state = state.copyWith(doctorsSpecialtyList: data);
      },
      failure: (apiErrorModel) {
        state = state.copyWith(errorMessage: apiErrorModel.errors);
      },
    );
  }
}
