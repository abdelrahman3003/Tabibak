import 'package:tabibak/features/auth/data/models/user_model.dart';

class ProfileStates {
  final bool isLogOutLoading;
  final bool isUploadLoading;
  final UserModel? user;
  final bool isLoggedOut;
  final String? errorMessage;

  ProfileStates({
    this.isLogOutLoading = false,
    this.isUploadLoading = false,
    this.isLoggedOut = false,
    this.user,
    this.errorMessage,
  });

  ProfileStates copyWith({
    bool? isLogOutLoading,
    bool? isUploadLoading,
    bool? isLoggedOut,
    UserModel? user,
    String? errorMessage,
  }) {
    return ProfileStates(
      isLogOutLoading: isLogOutLoading ?? false,
      isUploadLoading: isUploadLoading ?? false,
      isLoggedOut: isLoggedOut ?? false,
      user: user ?? user,
      errorMessage: errorMessage,
    );
  }
}
