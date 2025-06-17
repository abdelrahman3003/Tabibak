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
}
