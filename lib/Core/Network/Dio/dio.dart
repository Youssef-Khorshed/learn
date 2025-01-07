import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_project/Core/DI/dependencyInjection.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Network/internetconnection.dart';
import 'package:flutter_complete_project/Core/enums/localization.dart';
import 'package:flutter_complete_project/Core/lang/LocalCubit/local_cubit.dart';
import 'package:flutter_complete_project/Core/utils/secure_token.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  InternetConnectivity internetConnectivity;
  ApiService({required this.internetConnectivity});
  static Dio? _dio;
  Future<Dio> getDio(
      {Map<String, dynamic>? header,
      String? contentType,
      String? token}) async {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio();

      // Configure Dio options (timeouts, etc.)
      _dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      _addDioInterceptor();
    }
    // Add default headers and interceptors

    String language = getit.get<LocalCubit>().localizationThemeState ==
            LocalizationThemeState.ar
        ? "ar"
        : "en";
    var token = await SecureToken.getToken();
    _addDioHeaders(language: language, token: token, contentType: contentType);
    return _dio!;
  }

  // Function to set default headers
  static void _addDioHeaders(
      {String? token,
      String language = 'ar',
      String? contentType,
      Map<String, dynamic>? header}) {
    _dio?.options.contentType = contentType ?? 'application/json';
    _dio?.options.headers = header ??
        {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', //'Bearer your_token_here', // You can add a token dynamically if needed
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
      _dio = await getDio();
      final response = await _dio!.get(url, queryParameters: queryParameters);
      if (response.statusCode != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        } else {
          throw ServerException(
            message: response.toString(),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }

  // Function to make POST requests
  Future<T> postRequest<T>(
      {required String url,
      dynamic body,
      Map<String, dynamic>? contentType}) async {
    if (await internetConnectivity.isConnected) {
      _dio = await getDio(contentType: contentType);
      final response = await _dio!.post(url, data: body);
      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return response.data;
        } else {
          throw ServerException(
            message: response.toString(),
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
      _dio = await getDio();
      final response = await _dio!.put(
        url,
        data: json.encode(body), // Send the body as JSON
      );

      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return response.data;
        } else {
          throw ServerException(
            message: response.toString(),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }

  // Function to make DELETE requests
  Future<T> deleteRequest<T>(
    String url,
  ) async {
    if (await internetConnectivity.isConnected) {
      _dio = await getDio();
      final response = await _dio!.delete(url);
      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return response.data;
        } else {
          throw ServerException(
            message: response.toString(),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }
}
