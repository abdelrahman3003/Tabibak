import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/services/env_service.dart';
import 'package:tabibak/core/services/push_notification_service.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/home/data/model/clinic_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this.supabase);
  final SupabaseClient supabase;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(serverClientId: EnvService.googleClientId);
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required int cityId,
  }) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        "name": name,
        "city_id": cityId,
      },
      emailRedirectTo: "myapp://auth-callback",
    );
  }

  Future<bool> login(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);
    final user = response.user;
    if (user == null) {
      throw const AuthException('Login failed');
    }
    if (user.emailConfirmedAt == null) {
      await supabase.auth.signOut();
      throw const AuthException('email_not_confirmed');
    }
    final exitUser = await getUserById(user.id);
    final fcmToken = await PushNotificationService.getToken();
    if (exitUser == null) {
      await addUserData(
        UserModel(
          userId: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'] ?? '',
          image: user.userMetadata?['avatar_url'],
          fcmToken: fcmToken,
        ),
      );

      return false;
    }

    await supabase.from('users').update({
      'fcm_token': fcmToken,
    }).eq('user_id', user.id);

    return exitUser.cityId != null;
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

  Future<bool> nativeGoogleSignIn() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw 'Google sign in cancelled';
    }

    final googleAuth = await googleUser.authentication;

    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) throw 'No Access Token found.';
    if (idToken == null) throw 'No ID Token found.';

    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final user = response.user;

    if (user == null) {
      throw 'Supabase sign-in failed.';
    }
    final existingUser = await getUserById(user.id);

    final fcmToken = await PushNotificationService.getToken();

    if (existingUser == null) {
      await addUserData(
        UserModel(
          userId: user.id,
          email: user.email ?? '',
          name: user.userMetadata?['name'] ?? '',
          image: user.userMetadata?['avatar_url'],
          fcmToken: fcmToken,
        ),
      );

      return false;
    }

    await Future.delayed(const Duration(milliseconds: 300));

    return existingUser.cityId != null;
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

  Future<List<CityModel>> getCities() async {
    final response = await supabase
        .from('city')
        .select('id, name_ar, name_en')
        .order('name_ar');

    return (response as List)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateUserCity({
    required int cityId,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw const AuthException('User not logged in');
    }

    await supabase.from('users').update({
      'city_id': cityId,
    }).eq('user_id', user.id);
  }

  Future<void> signOut() async {
    return await supabase.auth.signOut();
  }
}
