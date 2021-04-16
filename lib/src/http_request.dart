import 'package:dio/dio.dart';
import 'http_request_impl.dart';

abstract class HttpRequest {
  factory HttpRequest(String serverUrl, String apiKey) = HttpRequestImpl;

  // MeiliSearch server URL.
  final String serverUrl;

  // API key for authenticating with MeiliSearch server.
  final String apiKey;

  // GET method
  Future<Response<T>> get_method<T>(String path,
      {Map<String, dynamic> queryParameters});

  // POST method
  Future<Response<T>> post_method<T>(String path,
      {dynamic data, Map<String, dynamic> queryParameters});

  // PUT method
  Future<Response<T>> put_method<T>(String path,
      {dynamic data, Map<String, dynamic> queryParameters});

  // DELETE method
  Future<Response<T>> delete_method<T>(String path, {dynamic data});
}
