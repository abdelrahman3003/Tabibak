import 'package:tabibak/features/auth/data/models/user_model.dart';

class ProffileStates {
  final bool isLogOutLoading;
  final bool isUploadLoading;

  final UserModel? user;
  final String? errorMessage;

  ProffileStates({
    this.isLogOutLoading = false,
    this.isUploadLoading = false,
    this.user,
    this.errorMessage,
  });

  ProffileStates copyWith({
    bool? isLogOutLoading,
    bool? isUploadLoading,
    UserModel? user,
    String? errorMessage,
  }) {
    return ProffileStates(
      isLogOutLoading: isLogOutLoading ?? false,
      isUploadLoading: isUploadLoading ?? false,
      user: user ?? user,
      errorMessage: errorMessage ?? errorMessage,
    );
  }
}
