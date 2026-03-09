import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<ApiResult<void>> signIn(
      {required String email, required String password});
  Future<ApiResult<void>> nativeGoogleSignIn();
  Future<ApiResult<void>> signUp(
      {required String name, required String email, required String password});
  Future<ApiResult<void>> sendOtp({required String email});
  Future<ApiResult<void>> verifyOtpCode(
      {required UserModel userModel, required String otp});
  Future<ApiResult<UserResponse>> resetPassword({required String newPassword});
  Future<ApiResult<void>> signOut();
}
