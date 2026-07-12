import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:meilisearch/src/http_request.dart';
import 'package:test/test.dart';

/// A dio adapter that captures the outgoing request and returns a canned
/// empty JSON response, so the test does not need a running Meilisearch server.
class _CapturingAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('HttpRequest query parameters', () {
    test('null values are stripped so dio does not throw (issue #444)',
        () async {
      final adapter = _CapturingAdapter();
      final http = HttpRequest('http://localhost:7700', null, null, adapter);

      // Before the fix, null values in queryParameters made dio throw
      // `type 'Null' is not a subtype of type 'Object'`.
      await expectLater(
        http.getMethod<Map<String, dynamic>>(
          '/indexes',
          queryParameters: <String, Object?>{
            'limit': 20,
            'offset': null,
            'filter': null,
          },
        ),
        completes,
      );

      // The null-valued entries must not reach the request.
      expect(adapter.lastRequest, isNotNull);
      expect(adapter.lastRequest!.queryParameters, {'limit': 20});
    });
  });
}
