import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/services/env_service.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this.supabase);
  final SupabaseClient supabase;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(serverClientId: EnvService.googleClientId);
  Future<AuthResponse> signUp(
      {required String name,
      required String email,
      required String password}) async {
    final result = await supabase.auth.signUp(
        data: {"name": name},
        email: email,
        password: password,
        emailRedirectTo: "myapp://auth-callback");
    return result;
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) throw const AuthException('Login failed');
    if (user.emailConfirmedAt == null) {
      await supabase.auth.signOut();
      throw const AuthException('email_not_confirmed');
    } else {
      final existingUser = await getUserById(user.id);
      if (existingUser == null) {
        final newUser = UserModel(
          name: user.userMetadata?['name'] ?? 'User',
          email: user.email ?? '',
          userId: user.id,
        );
        await addUserData(newUser);
      }
    }

    return response;
  }

  Future<void> sendOtp(String email) async {
    return await supabase.auth.signInWithOtp(email: email);
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await supabase.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.email,
    );
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
    final existingUser = await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .maybeSingle();

    existingUser != null && existingUser['image'] != null
        ? existingUser['image']
        : googleUser.photoUrl;
  }

  Future<void> addUserData(UserModel userModel) async {
    await supabase
        .from('users')
        .upsert(userModel.toJson(), onConflict: 'user_id');
  }

  Future<UserModel?> getUserById(String userId) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response != null ? UserModel.fromJson(response) : null;
  }

  Future<void> signOut() async {
    return await supabase.auth.signOut();
  }
}
