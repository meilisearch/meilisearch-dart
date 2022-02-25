import 'package:test/test.dart';
import 'package:meilisearch/src/exception.dart';

import 'utils/client.dart'; // testServer

import "tests/analytics.dart"; // versionTests(), analyticsTests()
import "tests/documents.dart"; // documentsTests()

void main() {
  setUpAll(() {
    final String server = testServer; 
    print('\nUsing Meilisearch server on $server for running tests.\n');
  });

  group("Version", () {
    versionTests();
  }, tags: "analytics");
  
  group("Analytics", () {
    analyticsTests();
  }, tags: "analytics");

  group('Documents', () {
    documentsTests();
  }, tags: "documents");
}
