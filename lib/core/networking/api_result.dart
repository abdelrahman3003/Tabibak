import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tabibak/core/networking/api_error_model.dart';

part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.sucess(T data) = Success<T>;
  const factory ApiResult.failure(ApiErrorModel apiErrorModel) = Failure<T>;
}
