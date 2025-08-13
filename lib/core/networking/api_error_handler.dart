import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak/core/networking/api_error_model.dart';

// TODO: wallahy I will refactor this .. Omar Ahmed

class ErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(message: "Connection to server failure");
        case DioExceptionType.cancel:
          return ApiErrorModel(message: "Request to server was canceled");
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: "Connection timeout was the server");
        case DioExceptionType.unknown:
          return ApiErrorModel(
              message:
                  "Connection to server failed due to internet connection");
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
              message: "Recieve timeout to connectio with server");
        case DioExceptionType.badResponse:
          return handelError(error.response?.data);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(message: "Send time in connection with server");

        default:
          ApiErrorModel(message: "Something went wrong");
      }
    }
    if (error is AuthException) {
      return _mapSupabaseError(error);
    }
    return ApiErrorModel(message: "خطا غير معروف");
  }

  static ApiErrorModel _mapSupabaseError(AuthException error) {
    if (error.message.startsWith('Email address') &&
        error.message.contains('is invalid')) {
      return ApiErrorModel(message: "البريد الإلكتروني غير صالح");
    }
    switch (error.message) {
      case "validation_failed":
        return ApiErrorModel(message: "خطأ في التسجيل");
      case "missing email or phone":
        return ApiErrorModel(message: "يجب إدخال البريد الإلكتروني");
      case "Invalid login credentials":
        return ApiErrorModel(message: "بيانات تسجيل الدخول غير صحيحة");
      case "Signup requires a valid password":
        return ApiErrorModel(message: "كلمة المرور غير صحيحة");
      case "User already registered":
        return ApiErrorModel(message: "المستخدم مسجل بالفعل");
      case "Anonymous sign-ins are disabled":
        return ApiErrorModel(message: "تسجيل الدخول المجهول غير مفعل");
      case "Unable to validate email address: invalid format":
        return ApiErrorModel(message: "صيغة البريد الإلكتروني غير صحيحة");
      case "otp_expired":
        return ApiErrorModel(message: "انتهت صلاحية رمز التحقق");
      default:
        return ApiErrorModel(message: error.message);
    }
  }
}

ApiErrorModel handelError(dynamic data) {
  return ApiErrorModel(
      message: data['message'] ?? "Unknown error eccured",
      code: data['code'],
      errors: data['data']);
}
