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
          ["needs escapin' ", r"needs escapin\' "],
          "doesn\"t need escape",
          [r"fe\male", r'fe\\male'],
        ];

        for (var element in testData) {
          if (element is List<String>) {
            final value = element.first;
            final expected = element.last;

            expect(value.toMeiliValue().transform(), equals("'$expected'"));
          } else if (element is String) {
            expect(element.toMeiliValue().transform(), equals("'$element'"));
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
            equals('\'ArbitraryString\''));
      });
    });

    group('[AND]', () {
      // final exp1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue()).and(
      //       'tag'.toMeiliAttribute().eq("Tale".toMeiliValue()),
      //     );
    });
    group('[OR]', () {});
  });
}

class _ArbitraryClass {
  @override
  String toString() {
    return "ArbitraryString";
  }
}
