import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(
      {required String name,
      required String email,
      required String password}) async {
    return await supabase.auth
        .signUp(data: {"name": name}, email: email, password: password);
  }

  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<void> sendOtp(String email) async {
    return await supabase.auth.signInWithOtp(email: email);
  }

  Future<AuthResponse> verifyOtpCode(String email, String token) async {
    return await supabase.auth
        .verifyOTP(email: email, token: token, type: OtpType.email);
  }

  Future<UserResponse> resetPassword(String newPassword) async {
    return await supabase.auth
        .updateUser(UserAttributes(password: newPassword));
  }
}
