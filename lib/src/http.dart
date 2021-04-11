import 'package:dio/dio.dart';
import 'http_impl.dart';

abstract class Http {
  factory Http(String serverUrl, String apiKey) = HttpImpl;

  /// MeiliSearch server URL.
  final String serverUrl;

  /// API key for authenticating with MeiliSearch server.
  final String apiKey;

  /// GET method
  Future<Response<T>> get_method<T>(String path,
      {Map<String, dynamic> queryParameters});

  // /// POST method
  // Future<Response<T>> http_post<T>(String path);

  // /// PUT method
  // Future<Response<T>> http_put<T>(String path);

  // // DELETE method
  // Future<Response<T>> http_delete<T>(String path);
}
