import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpFactory {
  HttpFactory._();
  static http.Client? client;
  static final Logger logger = Logger();

  static http.Client getClient() {
    if (client == null) {
      client = http.Client();
    }
    return client!;
  }

  // Function to make GET requests
  static Future<http.Response> getRequest(
    String url,
  ) async {
    var client = getClient();
    try {
      // Log the request details
      logger.i('GET Request to: $url');
      logger.i('Headers: $defaultHeaders');

      // Make the GET request
      final response =
          await client.get(Uri.parse(url), headers: defaultHeaders());

      // Log the response
      logger.i('Response Status: ${response.statusCode}');
      logger.i('Response Body: ${response.body}');
      return response;
    } catch (e) {
      logger.e('Error during GET request: $e');
      rethrow;
    }
  }

  // Function to make POST requests
  static Future<http.Response> postRequest(String url, {dynamic body}) async {
    var client = getClient();
    try {
      // Log the request details
      logger.i('POST Request to: $url');
      logger.i('Headers: $defaultHeaders');
      logger.i('Request Body: $body');

      // Make the POST request
      final response = await client.post(Uri.parse(url),
          headers: defaultHeaders(), body: json.encode(body));

      // Log the response
      logger.i('Response Status: ${response.statusCode}');
      logger.i('Response Body: ${response.body}');
      return response;
    } catch (e) {
      logger.e('Error during POST request: $e');
      rethrow;
    }
  }

  // Function to make PUT requests
  static Future<http.Response> putRequest(String url, {dynamic body}) async {
    var client = getClient();
    try {
      // Log the request details
      logger.i('PUT Request to: $url');
      logger.i('Headers: $defaultHeaders');
      logger.i('Request Body: $body');

      // Make the PUT request
      final response = await client.put(Uri.parse(url),
          headers: defaultHeaders(), body: json.encode(body));

      // Log the response
      logger.i('Response Status: ${response.statusCode}');
      logger.i('Response Body: ${response.body}');
      return response;
    } catch (e) {
      logger.e('Error during PUT request: $e');
      rethrow;
    }
  }

  // Function to make DELETE requests
  static Future<http.Response> deleteRequest(
    String url,
  ) async {
    var client = getClient();
    try {
      // Log the request details
      logger.i('DELETE Request to: $url');
      logger.i('Headers: $defaultHeaders');

      // Make the DELETE request
      final response =
          await client.delete(Uri.parse(url), headers: defaultHeaders());

      // Log the response
      logger.i('Response Status: ${response.statusCode}');
      logger.i('Response Body: ${response.body}');
      return response;
    } catch (e) {
      logger.e('Error during DELETE request: $e');
      rethrow;
    }
  }

  // Add default headers if needed
  static Map<String, String> defaultHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer your_token', // If you have an authentication token
    };
  }
}
