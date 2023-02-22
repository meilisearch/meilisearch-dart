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
    return (map
          ..removeWhere((key, value) =>
              value == null || (value is Iterable && value.isEmpty)))
        .cast<String, Object>();
  }

  bool removeEmptyOrNulls(String key, Object? value) {
    return value == null || (value is Iterable && value.isEmpty);
  }
}

extension QueryMapExt on Map<String, Object?> {
  Map<String, Object> removeEmptyOrNullsFromMap() {
    return (this
          ..removeWhere((key, value) =>
              value == null || (value is Iterable && value.isEmpty)))
        .cast<String, Object>();
  }
}
