import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthResponse>> signIn(
      {required String email, required String password});
  Future<ApiResult<void>> nativeGoogleSignIn();
  Future<ApiResult<AuthResponse>> signUp(
      {required String name, required String email, required String password});
  Future<ApiResult<void>> sendOtp({required String email});
  Future<ApiResult<void>> verifyOtpCode(
      {required String email, required String otp});
  Future<ApiResult<UserResponse>> resetPassword({required String newPassword});
  Future<ApiResult<void>> addUserData(UserModel userModel);
  Future<ApiResult<void>> signOut();
}
