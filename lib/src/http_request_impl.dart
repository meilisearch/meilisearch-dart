import 'package:dio/dio.dart';
import 'package:meilisearch/src/version.dart';
import 'http_request.dart';
import 'exception.dart';

const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');

class HttpRequestImpl implements HttpRequest {
  HttpRequestImpl(this.serverUrl, this.apiKey, [this.connectTimeout])
      : dio = Dio(
          BaseOptions(
            baseUrl: serverUrl,
            headers: <String, Object>{
              if (apiKey != null) 'Authorization': 'Bearer $apiKey',
              if (!kIsWeb) 'User-Agent': Version.qualifiedVersion,
            },
            contentType: 'application/json',
            responseType: ResponseType.json,
            connectTimeout: connectTimeout ?? Duration(seconds: 5),
          ),
        );

  @override
  final String serverUrl;

  @override
  final String? apiKey;

  @override
  final Duration? connectTimeout;

  final Dio dio;

  @override
  Map<String, Object?> headers() {
    return dio.options.headers;
  }

  @override
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

  @override
  Future<Response<T>> postMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  @override
  Future<Response<T>> patchMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      return await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  @override
  Future<Response<T>> putMethod<T>(
    String path, {
    Object? data,
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      return throwException(e);
    }
  }

  @override
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
