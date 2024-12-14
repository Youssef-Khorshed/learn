import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/handlemessage.dart';
import 'package:flutter_complete_project/Core/Network/internetconnection.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  InternetConnectivity internetConnectivity;
  DioFactory({required this.internetConnectivity});
  static Dio? _dio;
  // Singleton Dio instance
  getDio() {
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
  static void _addDioHeaders({String? token, String language = 'en'}) {
    _dio?.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': token ??
          '', //'Bearer your_token_here', // You can add a token dynamically if needed
      'X-Locale': language
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
  Future<T> getRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (await internetConnectivity.isConnected) {
      final response =
          await getDio().get(url, queryParameters: queryParameters);
      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return response.data;
        } else {
          throw ServerException(
            message: getErrorMessage(response.statusCode!),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }

  // Function to make POST requests
  Future<T> postRequest<T>(String url, {dynamic body}) async {
    if (await internetConnectivity.isConnected) {
      final response = await getDio().post(url, data: body);
      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return response.data;
        } else {
          throw ServerException(
            message: getErrorMessage(response.statusCode!),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }

  // Function to make PUT requests
  Future<T> putRequest<T>(String url, {dynamic body}) async {
    if (await internetConnectivity.isConnected) {
      final response = await getDio().put(
        url,
        data: json.encode(body), // Send the body as JSON
      );

      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return response;
        } else {
          throw ServerException(
            message: getErrorMessage(response.statusCode!),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }

  // Function to make DELETE requests
  Future<T> deleteRequest<T>(String url) async {
    if (await internetConnectivity.isConnected) {
      final response = await getDio().delete(url);
      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return response.data;
        } else {
          throw ServerException(
            message: getErrorMessage(response.statusCode!),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }
}
