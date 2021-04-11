import 'package:test/test.dart';
import 'package:meilisearch/src/exception.dart';
import 'utils/client.dart';

void main() {
  setUpHttp();
  group('Exceptions', () {
    test('Throw exception with the detailed information from MeiliSearch',
        () async {
      expect(
          () async =>
              await http.get_method<Map<String, dynamic>>('/indexes/wrongUID'),
          throwsA(isA<MeiliSearchApiException>().having(
            (error) => error.errorCode, // Actual
            'errorCode', // Description of the check
            'index_not_found', // Expected
          )));
    });
    test('Throw basic 404 exception', () async {
      expect(
          () async =>
              await http.get_method<Map<String, dynamic>>('/wrong-path'),
          throwsA(isA<MeiliSearchApiException>().having(
            (error) => error.toString(), // Actual
            'toString() method', // Description of the check
            'MeiliSearchApiError - message: Http status error [404]', // Expected
          )));
    });
  });
}
