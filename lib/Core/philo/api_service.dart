import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/philo/api_failures.dart';
import 'package:flutter_complete_project/Core/philo/api_logger_print.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);

  Future<T> getData<T>({
    required Map<String, dynamic> queryParameters,
    required String path,
  }) async {
    try {
      ApiLoggerPrint.api(path);
      final response = await _dio.get(path,
          queryParameters: queryParameters, options: _addDioHeaders());
      ApiLoggerPrint.info('${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return data;
      } else {
        ApiLoggerPrint.error('${response.statusMessage}');
        throw ServerFailure(
            errorMessage: 'Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLoggerPrint.error('${e.message}');
      throw ServerFailure.fromDioError(e);
    }
  }

  Options? _addDioHeaders() {
    return Options(headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer your_token_here', // You can add a token dynamically if needed
    });
  }

  Future<T> postData<T>(
      {required String path,
      required Map<String, dynamic> data,
      Map<String, dynamic>? queryParameters,
      required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      ApiLoggerPrint.api(path);
      final response = await _dio.post(path,
          data: jsonEncode(data),
          queryParameters: queryParameters,
          options: _addDioHeaders());
      ApiLoggerPrint.info('${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        var receivedData = await jsonDecode(response.data);
        ApiLoggerPrint.error('$receivedData');
        return fromJson(receivedData);
      }
    } on DioException catch (e) {
      ApiLoggerPrint.error('${e.message}');
      throw ServerFailure.fromDioError(e);
    }
  }
}
