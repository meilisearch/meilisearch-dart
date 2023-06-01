import 'dart:convert';

import 'package:collection/collection.dart';

import 'filter_builder_base.dart';
import 'operators.dart';

const _eq = DeepCollectionEquality();

/// Represents an attribute path in a filter expression
class MeiliAttributeExpression extends MeiliExpressionBase {
  final List<String> parts;

  MeiliAttributeExpression(String path)
      : parts = _normalizeParts(path.split('.'));
  MeiliAttributeExpression.fromParts(List<String> parts)
      : parts = _normalizeParts(parts);

  static List<String> _normalizeParts(List<String> parts) {
    return parts
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  @override
  String transform() {
    return jsonEncode(parts.join('.'));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliAttributeExpression && _eq.equals(other.parts, parts);
  }

  @override
  int get hashCode => _eq.hash(parts);

  MeiliLessThanOperatorExpression operator <(MeiliValueExpressionBase value) {
    return MeiliLessThanOperatorExpression(property: this, value: value);
  }

  MeiliGreaterThanOperatorExpression operator >(
      MeiliValueExpressionBase value) {
    return MeiliGreaterThanOperatorExpression(property: this, value: value);
  }

  MeiliGreaterThanEqualsOperatorExpression operator >=(
      MeiliValueExpressionBase value) {
    return MeiliGreaterThanEqualsOperatorExpression(
        property: this, value: value);
  }

  MeiliLessThanEqualsOperatorExpression operator <=(
      MeiliValueExpressionBase value) {
    return MeiliLessThanEqualsOperatorExpression(property: this, value: value);
  }
}
