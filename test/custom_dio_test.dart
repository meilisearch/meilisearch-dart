import 'package:dio/dio.dart';

import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'models/adapter.dart';
import 'utils/client.dart';

class TestInterceptor extends Interceptor {
  bool onRequestCalled = false;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onRequestCalled = true;
    super.onRequest(options, handler);
  }
}

void main() {
  group('Custom dio', () {
    test('Interceptor', () async {
      final interceptor = TestInterceptor();
      final client = MeiliSearchClient.withCustomDio(
        testServer,
        apiKey: testApiKey,
        interceptors: [interceptor],
      );

      var health = await client.health();

      expect(health, {'status': 'available'});
      expect(interceptor.onRequestCalled, equals(true));
    });
    test("Adapter", () async {
      final adapter = createTestAdapter();
      final client = MeiliSearchClient.withCustomDio(
        testServer,
        apiKey: testApiKey,
        adapter: adapter,
      );

      var health = await client.health();

      expect(health, {'status': 'available'});
      expect(adapter.fetchCalled, equals(true));
    });
  });
}
