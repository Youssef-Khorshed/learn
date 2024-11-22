import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  /// private constructor to prevent instantiating the class
  DioFactory._();
  static Dio? _dio;
  // Singleton Dio instance
  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio();

      // Configure Dio options (timeouts, etc.)
      _dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      // Add default headers and interceptors
      _addDioHeaders();
      _addDioInterceptor();
    }

    return _dio!;
  }

  // Function to set default headers
  static void _addDioHeaders() {
    _dio?.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer your_token_here', // You can add a token dynamically if needed
    };
  }

  // Function to add PrettyDioLogger interceptor for logging
  static void _addDioInterceptor() {
    _dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }

  // Function to make GET requests
  static Future<Response> getRequest(String url) async {
    try {
      final response = await getDio().get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Function to make POST requests
  static Future<Response> postRequest(String url, {dynamic body}) async {
    try {
      final response = await getDio().post(
        url,
        data: json.encode(body), // Send the body as JSON
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Function to make PUT requests
  static Future<Response> putRequest(String url, {dynamic body}) async {
    try {
      final response = await getDio().put(
        url,
        data: json.encode(body), // Send the body as JSON
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Function to make DELETE requests
  static Future<Response> deleteRequest(String url) async {
    try {
      final response = await getDio().delete(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
