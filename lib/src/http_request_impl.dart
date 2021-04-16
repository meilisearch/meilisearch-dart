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
  Future<Response<T>> get_method<T>(String path,
      {Map<String, dynamic> queryParameters}) async {
    var response;
    try {
      response = await dio.get<T>(path, queryParameters: queryParameters);
    } on DioError catch (e) {
      throw MeiliSearchApiException(e.message, e.response.data);
    }
    return await response;
  }

  // Future<Response<T>> post_method<T>(String path);

  // Future<Response<T>> put_method<T>(String path);

  // Future<Response<T>> delete_method<T>(String path);
}
