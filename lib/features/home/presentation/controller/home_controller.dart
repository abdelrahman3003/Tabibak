import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/data_source/home_remote_data.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/data/model/specialise_model.dart';
import 'package:tabibak/features/home/domain/repo/home_repo.dart';
import 'package:tabibak/features/home/domain/repo/home_repo_imp.dart';
import 'package:tabibak/features/home/presentation/controller/home_states.dart';
import 'package:tabibak/gen/assets.gen.dart';

final indexScreenProvider = StateProvider<int>((ref) {
  return 0;
});
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

class HomeController extends StateNotifier<HomeStates> {
  HomeController(this.ref) : super(HomeIniail()) {
    initData();
  }
  final Ref ref;

  void initData() async {
    await fetchUserById();
    await fetchSpecialties();
    await fetchAllDoctors();
  }

  UserModel? userModel;
  List<DoctorModel>? doctorsList;
  List<SpecialiseModel>? specialiseModelList;
  Future<void> fetchSpecialties() async {
    state = HomeSpecialitesLoading();
    final result = await ref.read(homrepoProvider).fetchSpecialties();
    result.when(
      sucess: (data) {
        specialiseModelList = data;
        state = HomeSpecialitesSuccess();
      },
      failure: (apiErrorModel) {
        state = HomeSpecialitesFailure();
      },
    );
  }

  Future<void> fetchUserById() async {
    state = HomeSpecialitesLoading();
    final result = await ref.read(homrepoProvider).getUserData();
    result.when(
      sucess: (data) {
        userModel = data;
        state = HomeFechDataUserSuccess();
      },
      failure: (apiErrorModel) {
        state = HomeSpecialitesFailure();
      },
    );
  }

  Future<void> fetchAllDoctors() async {
    state = HomeFechAllDoctorsLoading();
    final result = await ref.read(homrepoProvider).fetchAllDoctors();
    result.when(
      sucess: (data) {
        doctorsList = data;
        state = HomeFechAllDoctorsSuccess();
      },
      failure: (apiErrorModel) {
        state = HomeFechAllDoctorsFailure();
      },
    );
  }
}
