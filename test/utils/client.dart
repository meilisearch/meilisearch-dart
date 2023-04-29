import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:meilisearch/src/http_request.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

HttpRequest get http => client.http;
late MeiliSearchClient client;
Random random = Random();

String get testServer {
  return Platform.environment['MEILISEARCH_URL'] ?? 'http://localhost:7700';
}

void setUpClient() {
  setUp(() {
    final String server = testServer;
    const masterKey = 'masterKey';
    client = MeiliSearchClient(server, masterKey);
    random = Random();
  });
}

void setUpClientWithWrongUrl() {
  setUp(() {
    final String server = 'http://wrongurl:1234';
    final connectTimeout = Duration(milliseconds: 1000);
    const masterKey = 'masterKey';

    client = MeiliSearchClient(server, masterKey, connectTimeout);
  });
}

String randomUid([String prefix = 'index']) {
  return '${prefix}_${random.nextInt(9999)}';
}

// Stolen from: https://www.kindacode.com/article/flutter-dart-ways-to-generate-random-strings/
String sha1RandomString() {
  final randomNumber = random.nextDouble();
  final randomBytes = utf8.encode(randomNumber.toString());

  return sha1.convert(randomBytes).toString();
}
