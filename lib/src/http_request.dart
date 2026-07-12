import 'package:dio/dio.dart';
import 'version.dart';

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

  /// Removes entries whose value is `null` from [queryParameters].
  ///
  /// Dio throws `type 'Null' is not a subtype of type 'Object'` when the
  /// query parameters map contains null values, so they are stripped out
  /// before the request is sent. A null value simply means the parameter is
  /// not set.
  ///
  /// See https://github.com/meilisearch/meilisearch-dart/issues/444
  static Map<String, Object?>? _sanitizeQueryParameters(
    Map<String, Object?>? queryParameters,
  ) {
    if (queryParameters == null) {
      return null;
    }

    return <String, Object?>{
      for (final entry in queryParameters.entries)
        if (entry.value != null) entry.key: entry.value,
    };
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
        queryParameters: _sanitizeQueryParameters(queryParameters),
        data: data,
      );
    } on DioException catch (e) {
      return _throwException(e);
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
        queryParameters: _sanitizeQueryParameters(queryParameters),
        options: Options(
          contentType: contentType,
        ),
      );
    } on DioException catch (e) {
      return _throwException(e);
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
        queryParameters: _sanitizeQueryParameters(queryParameters),
        options: Options(
          contentType: contentType,
        ),
      );
    } on DioException catch (e) {
      return _throwException(e);
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
        queryParameters: _sanitizeQueryParameters(queryParameters),
        options: Options(
          contentType: contentType,
        ),
      );
    } on DioException catch (e) {
      return _throwException(e);
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
        queryParameters: _sanitizeQueryParameters(queryParameters),
      );
    } on DioException catch (e) {
      return _throwException(e);
    }
  }

  Never _throwException(DioException e) {
    final message = e.message ?? '';
    if (e.type == DioExceptionType.badResponse) {
      throw MeiliSearchApiException.fromHttpBody(message, e.response?.data);
    } else {
      throw CommunicationException(message);
    }
  }
}
