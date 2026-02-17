import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak/core/helper/dependancy_injection.dart';
import 'package:tabibak/core/helper/shared_pref.dart';
import 'package:tabibak/features/auth/data/repo/auth_repo.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/profile/data/repo/profile_repo.dart';
import 'package:tabibak/features/profile/presentation/manager/profile_states.dart';

final themeStateProvider = StateProvider<bool>(
    (ref) => SharedPrefsService.prefs.getBool(SharedPrefKeys.isDark) ?? false);
final profileLogout =
    StateNotifierProvider.autoDispose<ProfileController, ProfileStates>(
        (ref) => ProfileController(ref, getIt<AuthRepository>()));
final profileProviderController =
    StateNotifierProvider.autoDispose<ProfileController, ProfileStates>(
        (ref) => ProfileController(ref, getIt<AuthRepository>()));
final profileRepoProvider = AutoDisposeProvider<ProfileRepo>((ref) {
  return getIt<ProfileRepo>();
});

class ProfileController extends StateNotifier<ProfileStates> {
  ProfileController(this.ref, this.authRepo) : super(ProfileStates());
  final Ref ref;
  final AuthRepository authRepo;
  logOut(BuildContext context) async {
    state = state.copyWith(isLogOutLoading: true, errorMessage: null);
    final result = await authRepo.signOut();
    result.when(sucess: (_) async {
      state = state.copyWith(isLoggedOut: true);
    }, failure: (error) {
      state = state.copyWith(errorMessage: error.message);
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
        ref.read(homeControllerProvider.notifier).getUserById();
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
