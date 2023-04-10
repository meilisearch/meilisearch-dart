import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

void main() {
  group('Filter builder', () {
    group("Attributes", () {
      test('basic transform', () {
        expect(Meili.attr('book_id').transform(), equals("book_id"));
        expect(Meili.attr('book.id').transform(), equals("book.id"));
        expect(Meili.attr('   book.  id   ').transform(), equals("book.id"));
        expect(Meili.attr('   book.id.   ').transform(), equals("book.id"));
      });
    });

    group("Values", () {
      test("Strings", () {
        //
        final testData = <Object>[
          "Hello",
          "hello",
          "hello!",
          "hello spaces",
          "doesn't need escape",
          ['needs escape"', 'needs escape\\"'],
          [r"fe\male", r'fe\\male'],
        ];

        for (var element in testData) {
          if (element is List<String>) {
            final value = element.first;
            final expected = element.last;

            expect(value.toMeiliValue().transform(), equals("\"$expected\""));
          } else if (element is String) {
            expect(element.toMeiliValue().transform(), equals("\"$element\""));
          }
        }
      });

      test("Booleans", () {
        final testData = [
          [true, "true"],
          [false, "false"],
        ];
        for (var element in testData) {
          final value = element.first;
          final expected = element.last;

          expect(Meili.value(value).transform(), equals(expected));
        }
      });

      test("Numbers", () {
        final testData = [
          [10, "10"],
          [11.5, "11.5"],
        ];

        for (var element in testData) {
          final value = element.first;
          final expected = element.last;

          expect(Meili.value(value).transform(), equals(expected));
        }
      });
      test("Dates", () {
        final testData = [
          [DateTime.utc(1999, 12, 14, 18, 53, 56), '945197636000'],
        ];

        for (var element in testData) {
          final value = element.first;
          final expected = element.last;

          expect(Meili.value(value).transform(), equals(expected));
        }

        expect(
          () => Meili.value(DateTime(1999, 12, 14, 18, 53, 56)),
          throwsA(
            isA<AssertionError>().having(
              (p0) => p0.message,
              'message',
              equals(
                  "DateTime passed to Meili must be in UTC to avoid inconsistency accross multiple devices"),
            ),
          ),
        );
      });

      test("Arbitrary", () {
        expect(Meili.value(_ArbitraryClass()).transform(),
            equals('"ArbitraryString"'));
      });
    });

    group('[AND]', () {
      test("No expressions", () {
        final and = Meili.and([]);
        expect(and.transform(), equals(""));
      });
      test("One expressions", () {
        final expr1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue());
        final and = Meili.and([expr1]);
        expect(and.transform(), equals(expr1.transform()));
      });
      test("Two expressions", () {
        final expr1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue());
        final expr2 = 'tag'.toMeiliAttribute().eq("Tale".toMeiliValue());
        final expr = expr1.and(expr2);
        expect(expr.transform(), "(book_id < 100) AND (tag = \"Tale\")");
      });
      test("Three expressions", () {
        final expr1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue());
        final expr2 = 'tag'.toMeiliAttribute().eq("Tale".toMeiliValue());
        final expr3 = 'tag'.toMeiliAttribute().exists();
        final expr = expr1.andList([expr2, expr3]);
        expect(expr.transform(),
            "(book_id < 100) AND (tag = \"Tale\") AND (tag EXISTS)");
      });
    });
    group('[OR]', () {});

    /// TODO(ahmednfwela): waiting for Meili V1.2.0
    // test("[NULL]", () {
    //   final expr = "tag".toMeiliAttribute().isNull();
    //   expect(expr.transform(), "tag NULL");
    // });
  });
}

class _ArbitraryClass {
  @override
  String toString() {
    return "ArbitraryString";
  }
}
