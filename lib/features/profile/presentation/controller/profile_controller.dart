import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/routes.dart';
import 'package:tabibak/core/services/shared_pref_service.dart';
import 'package:tabibak/features/profile/data/profile_remote_data_source.dart';
import 'package:tabibak/features/profile/domain/profile_repo.dart';
import 'package:tabibak/features/profile/domain/profile_repo_imp.dart';
import 'package:tabibak/features/profile/presentation/controller/proffile_states.dart';

final profileProviderController =
    StateNotifierProvider.autoDispose<ProfileController, ProfileStates>(
        (ref) => ProfileController(ref));
final profileRepoProvider = AutoDisposeProvider<ProfileRepo>((ref) {
  return ProfileRepoImp(profileRemoteDataSource: ProfileRemoteDataSource());
});

class ProfileController extends StateNotifier<ProfileStates> {
  ProfileController(this.ref) : super(ProfileInitial());
  final Ref ref;
  logOut(BuildContext context) async {
    state = LogOutLoading();
    final result = await ref.read(profileRepoProvider).signOut();
    result.when(sucess: (_) {
      SharedPrefsService.prefs.clear();
      state = LogOutSuccess();
      context.pushNamedAndRemoveUntil(Routes.singinView,
          predicate: (route) => false);
    }, failure: (error) {
      state = LogOutFailed();
    });
  }
}
