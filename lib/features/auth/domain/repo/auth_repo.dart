import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_result.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthResponse>> login(
      {required String email, required String password});
  Future<ApiResult<void>> loginWithGoogle();
  Future<ApiResult<AuthResponse>> signUp(
      {required String name, required String email, required String password});
  Future<ApiResult<void>> sendOpt({required String email});
  Future<ApiResult<void>> verifyOtpCode(
      {required String email, required String token});
  Future<ApiResult<UserResponse>> resetPassword({required String newPassword});
}
