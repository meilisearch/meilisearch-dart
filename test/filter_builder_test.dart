import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

void main() {
  group('Filter builder', () {
    group("Attributes", () {
      test('basic transform', () {
        expect('book_id'.toMeiliAttribute().transform(), equals("book_id"));
        expect('book.id'.toMeiliAttribute().transform(), equals("book.id"));
        expect('   book.  id   '.toMeiliAttribute().transform(),
            equals("book.id"));
        expect(
            '   book.id.   '.toMeiliAttribute().transform(), equals("book.id"));
      });
    });
    group("Values", () {
      test("Strings", () {
        //
        final testStrings = <Object>[
          "Hello",
          "hello",
          "hello!",
          "hello spaces",
          ["needs escapin' ", r"needs escapin\' "],
          "doesn\"t need escape",
          [r"fe\male", r'fe\\male'],
        ];
        for (var element in testStrings) {
          if (element is List<String>) {
            final value = element.first;
            final expected = element.last;
            expect(value.toMeiliValue().transform(), equals("'$expected'"));
          } else if (element is String) {
            expect(element.toMeiliValue().transform(), equals("'$element'"));
          }
        }
      });
      test("Numbers", () {
        final testStrings = <Object>[
          [10, "10"],
          [11.5, "11.5"],
        ];
        for (var element in testStrings) {
          if (element is List<String>) {
            final value = element.first;
            final expected = element.last;
            expect(value.toMeiliValue().transform(), equals(expected));
          } else if (element is String) {
            expect(element.toMeiliValue().transform(), equals(element));
          }
        }
      });
      test("Dates", () {
        //
      });
      test("Arbitrary", () {});
    });
    group('[AND]', () {
      final exp1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue()).and(
            'tag'.toMeiliAttribute().eq("Tale".toMeiliValue()),
          );
    });
    group('[OR]', () {});
  });
}
