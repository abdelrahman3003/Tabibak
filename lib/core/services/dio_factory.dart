import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tabibak/core/services/env_service.dart';

class DioFactory {
  static Dio? dio;

  static Dio getDio() {
    Duration timeout = const Duration(seconds: 30);
    if (dio == null) {
      dio = Dio();
      dio!..options.connectTimeout = timeout;
      dio!..options.receiveTimeout = timeout;
      addDioInterPreter();
      addDioHEaders();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterPreter() {
    dio?.interceptors.add(PrettyDioLogger(
        requestBody: true, requestHeader: true, responseHeader: true));
  }

  static void addDioHEaders({bool isLogedin = true}) {
    dio?.options.headers = {
      "apikey": EnvService.apiKey,
    };
  }
}
