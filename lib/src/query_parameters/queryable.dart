abstract class Queryable {
  const Queryable();

  Map<String, Object> toQuery();

  Object toURIString(String key, Object value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    } else if (value is List) {
      return value.join(',');
    } else {
      return value;
    }
  }

  Map<String, Object> removeEmptyOrNullsFromMap(Map<String, Object?> map) {
    return (map..removeWhere(isEmptyOrNull)).cast<String, Object>();
  }

  bool isEmptyOrNull(String key, Object? value) {
    return value == null || (value is Iterable && value.isEmpty);
  }
}
