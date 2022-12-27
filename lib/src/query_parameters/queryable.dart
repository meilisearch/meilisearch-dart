import 'dart:mirrors';

class Queryable {
  Map<String, dynamic> toQuery() {
    return _buildMap()
      ..removeWhere(_removeEmptyOrNulls)
      ..updateAll(_toURIString);
  }

  // Load automatically all the declared fields from a query class.
  Map<String, dynamic> _buildMap() {
    var instanceMirror = reflect(this);
    var classMirror = instanceMirror.type;

    return classMirror.declarations.map((key, value) {
      if (value is VariableMirror) {
        return MapEntry(MirrorSystem.getName(value.simpleName),
            instanceMirror.getField(value.simpleName).reflectee);
      }

      // This will be removed in the toQuery() when `_removeEmptyOrNulls`
      // is invoked.
      return MapEntry('key', null);
    });
  }

  dynamic _toURIString(String key, dynamic value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    } else if (value is List) {
      return value.join(',');
    } else {
      return value;
    }
  }

  bool _removeEmptyOrNulls(String key, dynamic value) {
    return value == null || (value is List && value.isEmpty);
  }
}
