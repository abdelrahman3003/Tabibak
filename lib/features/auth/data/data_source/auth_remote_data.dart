import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/services/env_service.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource();
  final SupabaseClient supabase = Supabase.instance.client;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(serverClientId: EnvService.googleClientId);
  Future<AuthResponse> signUp(
      {required String name,
      required String email,
      required String password}) async {
    final reslut = await supabase.auth
        .signUp(data: {"name": name}, email: email, password: password);
    await addUserData(UserModel(
        userId: supabase.auth.currentUser!.id, name: name, email: email));

    return reslut;
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

  Future<void> nativeGoogleSignIn() async {
    final googleUser = await googleSignIn.signIn();

    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    await addUserData(UserModel(
        userId: supabase.auth.currentUser!.id,
        name: googleUser.displayName,
        email: googleUser.email));
  }

  Future<void> addUserData(UserModel userModel) async {
    await supabase
        .from('users')
        .upsert(userModel.toJson(), onConflict: 'user_id');
  }
}
