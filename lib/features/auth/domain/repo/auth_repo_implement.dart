import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak/features/auth/data/models/user_model.dart';
import 'package:tabibak/features/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<ApiResult<AuthResponse>> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final result = await remoteDatasource.signUp(
          name: name, email: email, password: password);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<AuthResponse>> login(
      {required String email, required String password}) async {
    try {
      final result = await remoteDatasource.login(email, password);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> nativeGoogleSignIn() async {
    try {
      final result = await remoteDatasource.nativeGoogleSignIn();
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> sendOpt({required String email}) async {
    try {
      final result = await remoteDatasource.sendOtp(email);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<AuthResponse>> verifyOtpCode(
      {required String email, required String token}) async {
    try {
      final result = await remoteDatasource.verifyOtpCode(email, token);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<UserResponse>> resetPassword(
      {required String newPassword}) async {
    try {
      final result = await remoteDatasource.resetPassword(newPassword);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<void>> addUserData(UserModel userModel) async {
    try {
      final result = await remoteDatasource.addUserData(userModel);
      return ApiResult.sucess(result);
    } catch (error) {
      log("0000000000000000 $error");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
