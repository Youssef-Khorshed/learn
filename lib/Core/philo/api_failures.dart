import 'package:dio/dio.dart';

abstract class Failures {
  String errorMessage;
  Failures({required this.errorMessage});
}

class ServerFailure extends Failures {
  ServerFailure({required super.errorMessage});
  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errorMessage: 'Connection Timeout');
      case DioExceptionType.sendTimeout:
        return ServerFailure(errorMessage: 'Send Timeout');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errorMessage: 'Receive Timeout');
      case DioExceptionType.badCertificate:
        return ServerFailure(errorMessage: 'Bad Certificate');
      case DioExceptionType.badResponse:
        return ServerFailure(errorMessage: 'Bad Response');
      case DioExceptionType.cancel:
        return ServerFailure(errorMessage: 'Request Cancelled');
      case DioExceptionType.connectionError:
        return ServerFailure(errorMessage: 'Connection Error');
      case DioExceptionType.unknown:
        return ServerFailure(errorMessage: 'Unknown Error');
      default:
        return ServerFailure(errorMessage: 'Opps Something went wrong');
    }
  }
  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errorMessage: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(errorMessage: 'Not Found');
    } else if (statusCode == 500) {
      return ServerFailure(errorMessage: 'Internal Server Error , Try again');
    } else {
      return ServerFailure(
          errorMessage: 'Opps Something went wrong , Try again');
    }
  }
}
