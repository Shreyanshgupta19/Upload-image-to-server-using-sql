import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upload_image_to_server_using_sql/data/app_exceptions.dart';
import 'package:upload_image_to_server_using_sql/data/network/base_api_service.dart';

// Define a provider for NetworkApiService
final networkApiServiceProvider = Provider<NetworkApiService>((ref) {
  return NetworkApiService();
});

class NetworkApiService implements BaseApiServices {
  late final Dio _dio;

  NetworkApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
      ),
    );

    // Adding interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Remove null query parameters
          options.queryParameters.removeWhere((key, value) => value == null);
          if (kDebugMode) {
            debugPrint(
              "Request [${options.method}] : ${options.uri}\n"
                  "Query: ${options.queryParameters}\n"
                  "Data: ${options.data}\n"
                  "Headers: ${options.headers}",
            );
          }
          return handler.next(options); // Continue the request
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              "Response [${response.statusCode}] (${response.requestOptions.path}) : ${response.data}",
            );
          }
          return handler.next(response); // Continue the response
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              "Error in request [${error.response?.statusCode}] : ${error.response?.data}",
            );
          }
          return handler.next(error); // Continue the error
        },
      ),
    );

    // Optional: Add log interceptor for debugging
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          responseBody: true,
          requestBody: true,
          error: true,
        ),
      );
    }
  }

  @override
  Future getGetApiResponse(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.get(url, queryParameters: data);
      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    try {
      final response = await _dio.post(url, data: data);
      return _handleResponse(response);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  // Handling responses based on HTTP status codes
  dynamic _handleResponse(Response response) {
    if (kDebugMode) {
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');
    }
    if (response == null || response.statusCode == null) {
      throw FetchDataException("Invalid response from the server.");
    }

    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
      case 404:
        throw UnauthorisedException(response.data.toString());
      case 500:
        throw FetchDataException('Internal server error');
      default:
        throw FetchDataException(
          'Unexpected error occurred: ${response.statusCode}',
        );
    }
  }

  Exception _handleDioError(DioException error) {
    if (kDebugMode) {
      debugPrint("Dio Error: ${error.message}");
      if (error.response != null) {
        debugPrint("Response Data: ${error.response?.data}");
        debugPrint("Response Status Code: ${error.response?.statusCode}");
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return FetchDataException("Network request timed out.");
      case DioExceptionType.badResponse:
        return FetchDataException("Bad response from server.");
      case DioExceptionType.connectionError:
        return NoInternetException("No Internet connection.");
      default:
        return FetchDataException(
          error.response?.data?["error"] ?? "Something went wrong!",
        );
    }
  }

  static String catchError(dynamic e) {
    if (e is DioException) {
      final response = e.response;
      if (response != null) {
        switch (response.statusCode) {
          case 500:
            return "Backend error occurred!";
          case 401:
            return response.data?["error"] ?? "Unauthorized access!";
          default:
            return response.data?["error"] ?? "An unexpected error occurred!";
        }
      }
      return "Something went wrong: ${e.message}";
    }
    return "Unexpected error: $e";
  }
}
