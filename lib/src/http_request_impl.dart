import 'package:dio/dio.dart';
import 'http_request.dart';
import 'exception.dart';

class HttpRequestImpl implements HttpRequest {
  HttpRequestImpl(this.serverUrl, this.apiKey)
      : dio = Dio(BaseOptions(
          baseUrl: serverUrl,
          headers: <String, dynamic>{
            if (apiKey != null) 'X-Meili-API-Key': apiKey,
          },
          responseType: ResponseType.json,
        ));

  @override
  final String serverUrl;

  @override
  final String apiKey;

  final Dio dio;

  @override
  Future<Response<T>> getMethod<T>(String path,
      {Map<String, dynamic> queryParameters}) async {
    var response;
    try {
      response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  @override
  Future<Response<T>> postMethod<T>(String path,
      {dynamic data, Map<String, dynamic> queryParameters}) async {
    var response;
    try {
      response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  @override
  Future<Response<T>> putMethod<T>(String path,
      {dynamic data, Map<String, dynamic> queryParameters}) async {
    var response;
    try {
      response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  @override
  Future<Response<T>> deleteMethod<T>(String path, {dynamic data}) async {
    var response;
    try {
      response = await dio.delete<T>(
        path,
        data: data,
      );
    } on DioError catch (e) {
      throwException(e);
    }
    return await response;
  }

  throwException(DioError e) {
    if (e.type == DioErrorType.RESPONSE) {
      throw MeiliSearchApiException(e.message, e.response.data);
    } else if (e.type == DioErrorType.DEFAULT) {
      throw CommunicationException(e.message);
    }
    throw e;
  }
}
