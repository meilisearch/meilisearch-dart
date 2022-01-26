import 'package:dio/dio.dart';
import 'http_request_impl.dart';

abstract class HttpRequest {
  factory HttpRequest(String serverUrl, String apiKey, [int connectTimeout]) =
      HttpRequestImpl;

  /// Meilisearch server URL.
  String get serverUrl;

  /// API key for authenticating with Meilisearch server.
  String? get apiKey;

  /// Timeout in milliseconds for opening a url.
  int? get connectTimeout;

  /// Retrieve all headers used when Http calls are made.
  Map<String, dynamic> headers();

  /// GET method
  Future<Response<T>> getMethod<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  /// PATCH method
  Future<Response<T>> patchMethod<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  /// POST method
  Future<Response<T>> postMethod<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  /// PUT method
  Future<Response<T>> putMethod<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  /// DELETE method
  Future<Response<T>> deleteMethod<T>(String path, {dynamic data});
}
