import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/services/logger_service.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio =>
      Dio(
          BaseOptions(
            baseUrl: 'https://api.example.com', // Replace with your base URL
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              LoggerService.d(
                'NETWORK REQUEST: [${options.method}] ${options.path}',
              );
              return handler.next(options);
            },
            onResponse: (response, handler) {
              LoggerService.d(
                'NETWORK RESPONSE: [${response.statusCode}] ${response.requestOptions.path}',
              );
              return handler.next(response);
            },
            onError: (DioException e, handler) {
              LoggerService.e(
                'NETWORK ERROR: [${e.response?.statusCode}] ${e.requestOptions.path}',
                e,
                e.stackTrace,
              );
              return handler.next(e);
            },
          ),
        );
}
