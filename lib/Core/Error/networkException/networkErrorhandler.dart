import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/exceptionType.dart';

class DioErrorHandler {
  const DioErrorHandler();

  static AppException handle(dynamic e) {
    if (e is DioException) {
      return _handleDioError(e);
    } else {
      return const NetworkException(
        type: NetworkExceptionType.unknown,
      );
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.badResponse:
        return _dioBadResponseExceptionToAppException(error);
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          type: NetworkExceptionType.connectionTimeout,
          code: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const NetworkException(type: NetworkExceptionType.cancel);
      case DioExceptionType.connectionError:
        return const NetworkException(
          type: NetworkExceptionType.noInternetConnection,
        );
      case DioExceptionType.badCertificate:
        return const NetworkException(
            type: NetworkExceptionType.badCertificate);
      case DioExceptionType.unknown:
        return const NetworkException(type: NetworkExceptionType.unknown);
    }
  }

  static NetworkException _dioBadResponseExceptionToAppException(
      DioException error) {
    final statusCode = error.response?.statusCode;
    return switch (statusCode) {
      /*bad request*/
      400 => const NetworkException(type: NetworkExceptionType.badRequest),
      /*unauthorized*/
      401 => const NetworkException(type: NetworkExceptionType.unauthorized),
      /*forbidden*/
      403 => const NetworkException(type: NetworkExceptionType.forbidden),
      /*not found*/
      404 => const NetworkException(type: NetworkExceptionType.notFound),
      /*conflict*/
      409 => const NetworkException(type: NetworkExceptionType.conflict),
      /*internal server error*/
      500 => const NetworkException(type: NetworkExceptionType.internal),
      /*bad gateway*/
      502 => const NetworkException(type: NetworkExceptionType.internal),
      /*service unavailable*/
      503 =>
        const NetworkException(type: NetworkExceptionType.serviceUnavailable),
      _ => _backendErrorResponseToAppException(error)
    };
  }

  // handle unknown error form server
  static NetworkException _backendErrorResponseToAppException(
      DioException error) {
    return error.response != null
        ? NetworkException(
            type: NetworkExceptionType.backend,
            code: error.response!.statusCode,
            message: _getStringmessage(
                json: error.response!.data as Map<String, dynamic>),
          )
        : const NetworkException(type: NetworkExceptionType.unknown);
  }

  static String _getStringmessage({required Map<String, dynamic> json}) {
    return json['message'] as String;
  }
}
