import 'package:dio/dio.dart';
import 'package:meilisearch/src/version.dart';

import 'exception.dart';

const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');

class HttpRequest {
  HttpRequest(
    this.serverUrl,
    this.apiKey, [
    this.connectTimeout,
    HttpClientAdapter? adapter,
    List<Interceptor>? interceptors,
  ]) : dio = Dio(
          BaseOptions(
            baseUrl: serverUrl,
            headers: <String, Object>{
              if (apiKey != null) 'Authorization': 'Bearer $apiKey',
              'X-Meilisearch-Client': [
                Version.qualifiedVersion,
                if (_kIsWeb) Version.qualifiedVersionWeb
              ].join(',')
            },
            responseType: ResponseType.json,
            connectTimeout: connectTimeout ?? Duration(seconds: 5),
          ),
        ) {
    if (adapter != null) {
      dio.httpClientAdapter = adapter;
    }

    dio.interceptors.removeImplyContentTypeInterceptor();

    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }
  }

  /// Meilisearch server URL.

  final String serverUrl;

  /// API key for authenticating with Meilisearch server.
  final String? apiKey;

  /// Timeout for opening a url.
  final Duration? connectTimeout;

  final Dio dio;

  /// Retrieve all headers used when Http calls are made.

  Map<String, Object?> headers() {
    return dio.options.headers;
  }

  /// GET method

  Future<Response<T>> getMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  /// POST method
  Future<Response<T>> postMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          contentType: contentType,
        ),
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  /// PATCH method

  Future<Response<T>> patchMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      return await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          contentType: contentType,
        ),
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  /// PUT method
  Future<Response<T>> putMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          contentType: contentType,
        ),
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  /// DELETE method
  Future<Response<T>> deleteMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  Never throwException(DioError e) {
    final message = e.message ?? '';
    if (e.type == DioErrorType.badResponse) {
      throw MeiliSearchApiException.fromHttpBody(message, e.response?.data);
    } else {
      throw CommunicationException(message);
    }
  }
}
