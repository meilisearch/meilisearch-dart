import 'package:test/test.dart';
import 'package:meilisearch/meilisearch.dart';

import 'utils/client.dart';

void main() {
  setUpClient();

  group('Exceptions', () {
    test('Throw exception with the detailed information from Meilisearch',
        () async {
      await expectLater(
        () => client.getIndex('wrongUID'),
        throwsA(isA<MeiliSearchApiException>().having(
          (error) => error.code, // Actual
          'code', // Description of the check
          'index_not_found', // Expected
        )),
      );
    });

    test('Throw basic 404 exception', () async {
      await expectLater(
        () => http.getMethod<Map<String, Object?>>('/wrong-path'),
        throwsA(isA<MeiliSearchApiException>().having(
          (error) => error.toString(), // Actual
          'toString() method', // Description of the check
          contains('404'), // Expected
        )),
      );
    });

    test('Throw a CommunicationException', () async {
      final wrongClient = MeiliSearchClient('http://wrongURL', 'masterKey');

      await expectLater(
        () => wrongClient.getIndex('test'),
        throwsA(isA<CommunicationException>()),
      );
    });
  });
}
