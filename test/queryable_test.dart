import 'package:meilisearch/src/query_parameters/queryable.dart';
import 'package:test/test.dart';

class FakeQueryClass extends Queryable {
  final int? myInteger;
  final String? myString;
  final DateTime? myDate;
  final List<int> myList;

  FakeQueryClass(
      {this.myInteger, this.myString, this.myDate, this.myList = const []});

  Map<String, Object?> buildMap() {
    return {
      'myInteger': myInteger,
      'myString': myString,
      'myDate': myDate,
      'myList': myList,
    };
  }

  @override
  Map<String, Object> toQuery() {
    return removeEmptyOrNullsFromMap(buildMap())..updateAll(toURIString);
  }
}

void main() {
  test('responds with non-null values', () {
    var query = FakeQueryClass(myList: [1, 2], myInteger: 99);

    expect(query.toQuery(), {
      'myList': '1,2',
      'myInteger': 99,
    });
  });

  test('supports all main types', () {
    var date = DateTime.now();
    var query = FakeQueryClass(
        myList: [1, 2], myInteger: 99, myString: 'foo', myDate: date);

    expect(query.toQuery(), {
      'myDate': date.toUtc().toIso8601String(),
      'myString': 'foo',
      'myList': '1,2',
      'myInteger': 99,
    });
  });
}
