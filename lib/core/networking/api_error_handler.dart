import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/networking/api_error_model.dart';

// TODO: wallahy I will refactor this .. Omar Ahmed

class ErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(message: AppStrings.connectionServerFailure);
        case DioExceptionType.cancel:
          return ApiErrorModel(message: AppStrings.requestServerCanceled);
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: AppStrings.connectionTimeoutServer);
        case DioExceptionType.unknown:
          return ApiErrorModel(message: AppStrings.internetConnectionFailed);
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(message: AppStrings.receiveTimeoutServer);
        case DioExceptionType.badResponse:
          return handelError(error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(message: AppStrings.sendTimeoutServer);

        default:
          return ApiErrorModel(message: AppStrings.somethingWentWrong);
      }
    }
    if (error is AuthException) {
      return mapSupabaseError(error);
    }
    return ApiErrorModel(message: AppStrings.unknownErrorOccurred);
  }

  static ApiErrorModel mapSupabaseError(AuthException error) {
    final apiError = error is AuthApiException ? error : null;

    if (error.message.startsWith('Email address') &&
        error.message.contains('is invalid')) {
      return ApiErrorModel(message: AppStrings.invalidEmailAddress);
    }

    switch (apiError?.code) {
      case "validation_failed":
        return ApiErrorModel(message: AppStrings.validationFailed);

      case "missing_email_or_phone":
        return ApiErrorModel(message: AppStrings.missingEmailOrPhone);

      case "email_not_confirmed":
        return ApiErrorModel(message: AppStrings.emailNotConfirm);

      case "invalid_credentials":
        return ApiErrorModel(message: AppStrings.invalidCredentials);

      case "weak_password":
        return ApiErrorModel(message: AppStrings.weakPassword);

      case "user_already_exists":
        return ApiErrorModel(message: AppStrings.userAlreadyExists);

      case "otp_expired":
        return ApiErrorModel(message: AppStrings.otpExpired);

      case "over_email_send_rate_limit":
        return ApiErrorModel(message: AppStrings.emailRateLimitExceed);

      case "email_address_invalid":
        return ApiErrorModel(message: AppStrings.emailAddressInvalid);

      default:
        return ApiErrorModel(message: error.message);
    }
  }
}

ApiErrorModel handelError(dynamic data) {
  return ApiErrorModel(
      message: data['message'] ?? AppStrings.unknownErrorOccurred,
      code: data['code'],
      errors: data['data']);
}
