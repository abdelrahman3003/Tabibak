import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_result.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthResponse>> login(
      {required String email, required String password});
  Future<ApiResult<AuthResponse>> signUp(
      {required String name, required String email, required String password});
}
