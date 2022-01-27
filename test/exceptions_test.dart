import 'package:test/test.dart';
import 'package:meilisearch/src/exception.dart';
import 'package:meilisearch/meilisearch.dart';

import 'utils/client.dart';

void main() {
  setUpHttp();
  setUpClient();
  group('Exceptions', () {
    test('Throw exception with the detailed information from Meilisearch',
        () async {
      expect(
          () async => await client.getIndex('wrongUID'),
          throwsA(isA<MeiliSearchApiException>().having(
            (error) => error.code, // Actual
            'code', // Description of the check
            'index_not_found', // Expected
          )));
    });
    test('Throw basic 404 exception', () async {
      expect(
          () async => await http.getMethod<Map<String, dynamic>>('/wrong-path'),
          throwsA(isA<MeiliSearchApiException>().having(
            (error) => error.toString(), // Actual
            'toString() method', // Description of the check
            'MeiliSearchApiError - message: Http status error [404]', // Expected
          )));
    });

    test('Throw a CommunicationException', () async {
      final wrong_client = MeiliSearchClient('http://wrongURL', 'masterKey');
      expect(() async => await wrong_client.getIndex('test'),
          throwsA(isA<CommunicationException>()));
    });
  });
}
