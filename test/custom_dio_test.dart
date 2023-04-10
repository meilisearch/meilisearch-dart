import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

class TestInterceptor extends Interceptor {
  bool onRequestCalled = false;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onRequestCalled = true;
    super.onRequest(options, handler);
  }
}

class TestAdapter extends IOHttpClientAdapter {
  bool fetchCalled = false;
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) {
    fetchCalled = true;
    return super.fetch(options, requestStream, cancelFuture);
  }
}

void main() {
  group('Custom dio', () {
    test('Interceptor', () async {
      final interceptor = TestInterceptor();
      final client = MeiliSearchClient.withCustomDio(
        testServer,
        apiKey: "masterKey",
        interceptors: [interceptor],
      );

      var health = await client.health();

      expect(health, {'status': 'available'});
      expect(interceptor.onRequestCalled, equals(true));
    });
    test("Adapter", () async {
      final adapter = TestAdapter();
      final client = MeiliSearchClient.withCustomDio(
        testServer,
        apiKey: "masterKey",
        adapter: adapter,
      );

      var health = await client.health();

      expect(health, {'status': 'available'});
      expect(adapter.fetchCalled, equals(true));
    });
  });
}
