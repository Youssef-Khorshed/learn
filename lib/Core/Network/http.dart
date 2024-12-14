import 'dart:convert';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/handlemessage.dart';
import 'package:flutter_complete_project/Core/Network/internetconnection.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpFactory {
  InternetConnectivity internetConnectivity;

  HttpFactory._({required this.internetConnectivity});
  static http.Client? client;
  static final Logger logger = Logger();

  // Add default headers if needed
  Map<String, String> defaultHeaders({
    String? token,
  }) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      //  'Authorization': 'Bearer your_token', // If you have an authentication token
    };
  }

  static http.Client getClient() {
    if (client == null) {
      client = http.Client();
    }
    return client!;
  }

  // Function to make GET requests
  Future<http.Response> getRequest(
    String url,
  ) async {
    var client = getClient();
    if (await internetConnectivity.isConnected) {
      final response =
          await client.get(Uri.parse(url), headers: defaultHeaders());
      if (response.statusCode == 200) {
        return response;
      } else {
        throw ServerException(
          message: getErrorMessage(response.statusCode),
        );
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
  }

  // Function to make POST requests
  Future<http.Response> postRequest(String url, {dynamic body}) async {
    var client = getClient();
    if (await internetConnectivity.isConnected) {
      // Make the POST request
      final response = await client.post(Uri.parse(url),
          headers: defaultHeaders(), body: json.encode(body));
      if (response.statusCode == 200) {
        return response;
      } else {
        throw ServerException(
          message: getErrorMessage(response.statusCode),
        );
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
  }

  // Function to make PUT requests
  Future<http.Response> putRequest(String url, {dynamic body}) async {
    var client = getClient();
    if (await internetConnectivity.isConnected) {
      // Make the PUT request
      final response = await client.put(Uri.parse(url),
          headers: defaultHeaders(), body: json.encode(body));
      if (response.statusCode == 200) {
        return response;
      } else {
        throw ServerException(
          message: getErrorMessage(response.statusCode),
        );
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
  }

  // Function to make DELETE requests
  Future<http.Response> deleteRequest(
    String url,
  ) async {
    var client = getClient();
    if (await internetConnectivity.isConnected) {
      // Make the POST request
      final response =
          await client.delete(Uri.parse(url), headers: defaultHeaders());
      if (response.statusCode == 200) {
        return response;
      } else {
        throw ServerException(
          message: getErrorMessage(response.statusCode),
        );
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
  }
}
