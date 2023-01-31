abstract class Queryable {
  Map<String, dynamic> toQuery();

  dynamic toURIString(String key, dynamic value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    } else if (value is List) {
      return value.join(',');
    } else {
      return value;
    }
  }

  bool removeEmptyOrNulls(String key, dynamic value) {
    return value == null || (value is List && value.isEmpty);
  }
}
