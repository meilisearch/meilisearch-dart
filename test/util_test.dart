import 'dart:io';

import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  group('parseHighligtableString', () {
    test('Empty string', () {
      final parsed = Meili.parseHighligtableString(
        text: '',
        preTag: '(',
        postTag: ')',
      );

      expect(parsed, hasLength(1));
      expect(parsed.first.text, '');
      expect(parsed.first.isHighlighted, false);
    });

    test('Same pre and post tags should throw', () {
      expect(
        () => Meili.parseHighligtableString(
          text: '',
          preTag: '(',
          postTag: '(',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test("Entire string should return 1 item", () {
      final testStr = 'hello world';
      final parsed = Meili.parseHighligtableString(
        text: '($testStr)',
        preTag: '(',
        postTag: ')',
      );

      expect(parsed, hasLength(1));
      expect(parsed.first.text, testStr);
      expect(parsed.first.isHighlighted, true);
    });

    test("duplicate end tags shouldn't affect result", () {
      final testStr = 'hello world';
      final parsed = Meili.parseHighligtableString(
        text: '($testStr))',
        preTag: '(',
        postTag: ')',
      );

      expect(parsed, hasLength(2));
      expect(parsed.first.text, testStr);
      expect(parsed.first.isHighlighted, true);
      expect(parsed.last.text, ')');
      expect(parsed.last.isHighlighted, false);
    });

    test("duplicate start tags will affect result", () {
      final testStr = 'hello world';
      final parsed = Meili.parseHighligtableString(
        text: '(($testStr)',
        preTag: '(',
        postTag: ')',
      );

      expect(parsed, hasLength(1));
      expect(parsed.first.text, '($testStr');
      expect(parsed.first.isHighlighted, true);
    });

    test("multiple highlights", () {
      final parsed = Meili.parseHighligtableString(
        text: '(hello) (world)',
        preTag: '(',
        postTag: ')',
      ).toList();

      expect(parsed, hasLength(3));
      expect(parsed[0].text, 'hello');
      expect(parsed[0].isHighlighted, true);
      expect(parsed[1].text, ' ');
      expect(parsed[1].isHighlighted, false);
      expect(parsed[2].text, 'world');
      expect(parsed[2].isHighlighted, true);
    });
  });
}
