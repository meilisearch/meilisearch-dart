import 'package:test/test.dart';

import 'utils/client.dart'; // testServer
import "tests/analytics.dart"; // versionTests(), analyticsTests()
import "tests/documents.dart"; // documentsTests()
import "tests/dump.dart"; // dumpTests()
import "tests/exceptions.dart"; // exceptionsTests()
import "tests/get_client_stats.dart"; // getClientStatsTests()
import "tests/get_keys.dart"; // getKeysTests()
import "tests/get_version.dart"; //getVersionTests()
import "tests/health.dart"; // healthTests(), healthFailTests()
import "tests/indexes.dart"; // indexesTests()
import "tests/search.dart"; // searchTests()
import "tests/settings.dart"; // settingsTests()

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

  group("Dump", () {
    dumpTests();
  }, tags: "dump");

  group("Exceptions", () {
    exceptionsTests();
  }, tags: "exceptions");

  group("Stats", () {
    getClientStatsTests();
  }, tags: "get_client_stats");

  group("Keys", () {
    getKeysTests();
  }, tags: "get_keys");

  group("Version", () {
    getVersionTests();
  }, tags: "get_version");

  group("Health", () {
    healthTests();
  }, tags: "health");

  group("Health Fail", () {
    healthFailTests();
  }, tags: "health");

  group("Indexes", () {
    indexesTests();
  }, tags: "indexes");

  group("Search", () {
    searchTests();
  }, tags: "search");

  group("Settings", () {
    settingsTests();
  }, tags: "settings");
}
