import 'dart:io';

import 'package:meilisearch/src/version.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  final RegExp semVer = new RegExp(
      r"version\:.(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?");

  group('Version', () {
    test('matches with the current package version in pubspec.yaml', () {
      final path = '${Directory.current.path}/pubspec.yaml';
      String data = new File(path).readAsStringSync();
      String? version = semVer.stringMatch(data)?.replaceFirst('version: ', '');

      expect(version, isNotNull);
      expect(Version.current, isNotNull);
      expect(Version.current, equals(version));
    });
  });

  group('Analytics', () {
    setUpClient();

    test('sends the User-Agent header in every call', () {
      final headers = client.http.headers();

      expect(headers.keys, contains('User-Agent'));
      expect(headers['User-Agent'], isNotNull);
    });

    test('has current version data from Version class', () {
      final headers = client.http.headers();

      expect(headers['User-Agent'], equals(Version.qualifiedVersion));
    });
  });
}
