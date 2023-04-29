import 'package:test/test.dart';
import 'package:meilisearch/meilisearch.dart';

import 'utils/client.dart';

void main() {
  group('Exceptions', () {
    setUpClient();

    test('Throw exception with the detailed information from Meilisearch',
        () async {
      expect(
        () async => await client.getIndex('wrongUID'),
        throwsA(isA<MeiliSearchApiException>().having(
          (error) => error.code, // Actual
          'code', // Description of the check
          'index_not_found', // Expected
        )),
      );
    });
    
    test('Throw basic 404 exception', () async {
      expect(
        () async => await http.getMethod<Map<String, Object?>>('/wrong-path'),
        throwsA(isA<MeiliSearchApiException>().having(
          (error) => error.toString(), // Actual
          'toString() method', // Description of the check
          'MeiliSearchApiError - message: The request returned an invalid status code of 404.', // Expected
        )),
      );
    });

    test('Throw a CommunicationException', () async {
      final wrongClient = MeiliSearchClient('http://wrongURL', 'masterKey');

      expect(
        () async => await wrongClient.getIndex('test'),
        throwsA(isA<CommunicationException>()),
      );
    });
  });
}
