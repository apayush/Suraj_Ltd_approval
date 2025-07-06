import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'api_client.dart';

class ApiService {
  static final _apiClient = GetIt.I<ApiClient>(); // Access shared AuthService

  // Example GET request
  static Future<Response> getData(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _apiClient.client.get(
        endpoint,
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  static Future<Response> postData(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.client.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      print('Error in POST request: $e');
      rethrow;
    }
  }

  static Future<Response> postDataFullUrl(
    String fullUrl, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _apiClient.client.post(
        fullUrl,
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      print('Error in POST request: $e');
      rethrow;
    }
  }

  /// PUT request
  static Future<Response> putData(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _apiClient.client.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      print('Error in PUT request: $e');
      rethrow;
    }
  }

  /// DELETE request
  static Future<Response> deleteData(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _apiClient.client.delete(
        endpoint,
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Multipart (File Upload) request
  static Future<Map<String, dynamic>> uploadFile(
    String endpoint, {
    required File file,
    String? fileKey = 'file', // The key to use for the file field
    Map<String, dynamic>?
    additionalData, // Any additional data to send with the file
  }) async {
    try {
      FormData formData = FormData.fromMap({
        fileKey!: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        if (additionalData != null) ...additionalData,
        // Include additional data if provided
      });

      final response = await _apiClient.client.post(endpoint, data: formData);
      return response.data;
    } catch (e) {
      print('Error in Multipart request: $e');
      return {};
    }
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
