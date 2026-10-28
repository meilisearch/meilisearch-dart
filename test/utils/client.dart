import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:meilisearch/src/http_request.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

import '../models/test_client.dart';

HttpRequest get http => client.http;
late TestMeiliSearchClient client;
final random = Random();
final _uidRandom = Random.secure();
int _uidCounter = 0;

const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');
String get testServer {
  const defaultUrl = 'http://localhost:7700';
  if (_kIsWeb) {
    return defaultUrl;
  } else {
    return Platform.environment['MEILISEARCH_URL'] ?? defaultUrl;
  }
}

/// Local path that 404s quickly. Use as export destination in tests to avoid
/// outbound HTTP / task-queue blocking (see export_test.dart).
String get exportSinkUrl => '$testServer/__sdk_test_export_sink';

String get testApiKey {
  return 'masterKey';
}

/// Parses a Meilisearch version, tolerating the `v` prefix used by CI and by
/// the Meilisearch docker tags (for example `v1.56.0`).
Version? _parseServerVersion(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  var normalized = raw.trim();
  if (normalized.startsWith('v') || normalized.startsWith('V')) {
    normalized = normalized.substring(1);
  }
  // Tags such as `v1.39` omit the patch version, which `Version.parse` rejects.
  while ('.'.allMatches(normalized).length < 2) {
    normalized = '$normalized.0';
  }
  return Version.parse(normalized);
}

Version? get meiliServerVersion {
  const meilisearchVersionKey = 'MEILISEARCH_VERSION';
  String? compileTimeValue = String.fromEnvironment(meilisearchVersionKey);
  if (compileTimeValue.isEmpty) {
    compileTimeValue = null;
  }
  if (_kIsWeb) {
    return _parseServerVersion(compileTimeValue);
  }
  return _parseServerVersion(
    Platform.environment[meilisearchVersionKey] ?? compileTimeValue,
  );
}

String? get openAiKey {
  const keyName = "OPEN_AI_API_KEY";
  String? compileTimeValue = String.fromEnvironment(keyName);
  if (compileTimeValue.isEmpty) {
    compileTimeValue = null;
  }
  if (_kIsWeb) {
    return compileTimeValue;
  } else {
    return Platform.environment[keyName] ?? compileTimeValue;
  }
}

void setUpClient() {
  setUp(() {
    client = TestMeiliSearchClient(testServer, testApiKey);
  });
  tearDown(() => client.disposeUsedResources());
}

String randomUid([String prefix = 'index']) {
  final timestampPart = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final counterPart =
      (_uidCounter++ & 0xffff).toRadixString(36).padLeft(4, '0');
  final randomPart =
      _uidRandom.nextInt(0x7fffffff).toRadixString(36).padLeft(7, '0');
  return '${prefix}_${timestampPart}_$counterPart$randomPart';
}

// Stolen from: https://www.kindacode.com/article/flutter-dart-ways-to-generate-random-strings/
String sha1RandomString() {
  final randomNumber = random.nextDouble();
  final randomBytes = utf8.encode(randomNumber.toString());

  return sha1.convert(randomBytes).toString();
}
