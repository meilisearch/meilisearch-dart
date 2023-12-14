import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

void main() {
  group('Filter builder', () {
    group("Attributes", () {
      test('basic transform', () {
        expect(Meili.attr('book_id').transform(), equals("\"book_id\""));
        expect(Meili.attr('book.id').transform(), equals("\"book.id\""));
        expect(
          Meili.attr('   book.  id   ').transform(),
          equals("\"book.id\""),
        );
        expect(Meili.attr('   book.id.   ').transform(), equals("\"book.id\""));
      });

      test('From Parts', () {
        final attr1 = Meili.attrFromParts(['contact', 'phone']);
        final attr2 = Meili.attr('contact.phone');

        expect(attr1, attr2);
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
          [DateTime.utc(1999, 12, 14, 18, 53, 56), '945197636'],
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
                "DateTime passed to Meili must be in UTC to avoid inconsistency accross multiple devices",
              ),
            ),
          ),
        );
      });

      test("Arbitrary", () {
        expect(
          Meili.value(_ArbitraryClass()).transform(),
          equals('"ArbitraryString"'),
        );
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

        expect(
          expr.transform(),
          "(\"book_id\" < 100) AND (\"tag\" = \"Tale\")",
        );
      });

      test("Three expressions", () {
        final expr1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue());
        final expr2 = 'tag'.toMeiliAttribute().eq("Tale".toMeiliValue());
        final expr3 = 'tag'.toMeiliAttribute().exists();
        final expr = expr1.andList([expr2, expr3]);

        expect(
          expr.transform(),
          "(\"book_id\" < 100) AND (\"tag\" = \"Tale\") AND (\"tag\" EXISTS)",
        );
      });
    });

    group('[OR]', () {
      test("No expressions", () {
        final or = Meili.or([]);

        expect(or.transform(), equals(""));
      });

      test("One expressions", () {
        final expr1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue());
        final or = Meili.or([expr1]);

        expect(or.transform(), equals(expr1.transform()));
      });

      test("Two expressions", () {
        final expr1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue());
        final expr2 = 'tag'.toMeiliAttribute().eq("Tale".toMeiliValue());
        final expr = expr1.or(expr2);

        expect(expr.transform(), "(\"book_id\" < 100) OR (\"tag\" = \"Tale\")");
      });

      test("Three expressions", () {
        final expr1 = 'book_id'.toMeiliAttribute().lt(100.toMeiliValue());
        final expr2 = 'tag'.toMeiliAttribute().eq("Tale".toMeiliValue());
        final expr3 = 'tag'.toMeiliAttribute().exists();
        final expr = expr1.orList([expr2, expr3]);

        expect(
          expr.transform(),
          "(\"book_id\" < 100) OR (\"tag\" = \"Tale\") OR (\"tag\" EXISTS)",
        );
      });
    });

    group("Geo", () {
      test('BoundingBox', () {
        final op = Meili.geoBoundingBox((lat: 10, lng: 5.3), (lat: 10, lng: 5));

        expect(op.transform(), '_geoBoundingBox([10,5.3],[10,5])');
      });

      test('Radius', () {
        final op = Meili.geoRadius((lat: 10, lng: 5.3), 15);

        //in chrome, this will output (15), while in VM it will output (15.0)
        expect(op.transform(), '_geoRadius(10,5.3,${15.0})');
      });
    });

    group('IS', () {
      test("NULL", () {
        final expr = "tag".toMeiliAttribute().isNull();
        expect(expr.transform(), "\"tag\" IS NULL");
      });

      test("NOT NULL", () {
        final expr = "tag".toMeiliAttribute().isNotNull();
        expect(expr.transform(), "\"tag\" IS NOT NULL");
      });

      test("EMPTY", () {
        final expr = "tag".toMeiliAttribute().isEmpty();
        expect(expr.transform(), "\"tag\" IS EMPTY");
      });

      test("NOT EMPTY", () {
        final expr = "tag".toMeiliAttribute().isNotEmpty();
        expect(expr.transform(), "\"tag\" IS NOT EMPTY");
      });
    });

    group('IN', () {
      test('Mixed Types', () {
        final expr = "tag".toMeiliAttribute().$in(Meili.values(["hello", 5]));
        expect(expr.transform(), "\"tag\" IN [\"hello\",5]");
      });
    });
  });
}

class _ArbitraryClass {
  @override
  String toString() {
    return "ArbitraryString";
  }
}
