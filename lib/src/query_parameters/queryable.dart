abstract class Queryable {
  const Queryable();

  ///For use with POST methods that can handle JSON types
  Map<String, Object?> buildMap();

  ///For use with GET methods that require queryParameters
  Map<String, Object> toQuery() {
    return toSparseMap()..updateAll((key, value) => toURIString(value));
  }

  ///Returns a map with only non-null and non-empty fields
  Map<String, Object> toSparseMap() {
    return removeEmptyOrNullsFromMap(buildMap());
  }

  Object toURIString(Object value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    } else if (value is List) {
      return value.join(',');
    } else {
      return value;
    }
  }

  static Map<String, Object> removeEmptyOrNullsFromMap(
    Map<String, Object?> map,
  ) {
    return (map..removeWhere(isEmptyOrNull)).cast<String, Object>();
  }

  static bool isEmptyOrNull(String key, Object? value) {
    return value == null || (value is Iterable && value.isEmpty);
  }
}
