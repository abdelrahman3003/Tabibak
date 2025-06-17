import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_error_handler.dart';
import 'package:tabibak/core/networking/api_result.dart';
import 'package:tabibak/features/auth/data/data_source/auth_remote_data.dart';
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
      log("-------------- error ${ErrorHandler.handle(error).message}");
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDatasource.login(email, password);
      return ApiResult.sucess(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
