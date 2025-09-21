import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider.dart';
import 'package:tabibak/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:tabibak/features/profile/data/repo/profile_repo.dart';
import 'package:tabibak/features/profile/data/repo/profile_repo_imp.dart';
import 'package:tabibak/features/profile/presentation/manager/proffile_states.dart';

final profileProviderController =
    StateNotifierProvider.autoDispose<ProfileController, ProffileStates>(
        (ref) => ProfileController(ref));
final profileLogout =
    StateNotifierProvider.autoDispose<ProfileController, ProffileStates>(
        (ref) => ProfileController(ref));
final profileRepoProvider = AutoDisposeProvider<ProfileRepo>((ref) {
  return ProfileRepoImp(profileRemoteDataSource: ProfileRemoteDataSource());
});

class ProfileController extends StateNotifier<ProffileStates> {
  ProfileController(this.ref) : super(ProffileStates());
  final Ref ref;

  logOut(BuildContext context) async {
    state = state.copyWith(isLogOutLoading: true);
    final result = await ref.read(profileRepoProvider).signOut();
    result.when(sucess: (_) {
      SharedPrefsService.prefs.clear();
      state = state.copyWith(isLogOutLoading: false);
      context.pushNamedAndRemoveUntil(
        Routes.singinView,
        (route) => false,
      );
    }, failure: (error) {
      state = state.copyWith(isLogOutLoading: false);
    });
  }

  Future<void> uploadAndSaveProfileImage() async {
    final image = await pickImageFromGallery();

    if (image == null) {
      return;
    }
    state = state.copyWith(isUploadLoading: true);

    final uploadResult =
        await ref.read(profileRepoProvider).uploadProfileImage(image);

    uploadResult.when(sucess: (imageUrl) async {
      final updateResult =
          await ref.read(profileRepoProvider).updateProfileImage(imageUrl);
      updateResult.when(sucess: (data) {
        ref.read(homeControllerPrvider.notifier).getUserById();
      }, failure: (err) {
        state = state.copyWith(isUploadLoading: false);
      });
    }, failure: (err) {
      state = state.copyWith(isUploadLoading: false);
    });
  }

  Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    return image;
  }
}
