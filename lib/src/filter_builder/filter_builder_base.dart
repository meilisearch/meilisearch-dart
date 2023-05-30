import 'dart:convert';

import 'operators.dart';

/// Represents an arbitrary filter expression
abstract class MeiliExpressionBase {
  const MeiliExpressionBase();
  String transform();
  @override
  String toString() => transform();
}

/// Represents a filter operator with either at least one operand
abstract class MeiliOperatorExpressionBase extends MeiliExpressionBase {
  const MeiliOperatorExpressionBase();

  MeiliAndOperatorExpression operator &(MeiliOperatorExpressionBase other) {
    return MeiliAndOperatorExpression(first: this, second: other);
  }

  MeiliOrOperatorExpression operator |(MeiliOperatorExpressionBase other) {
    return MeiliOrOperatorExpression(first: this, second: other);
  }

  MeiliNotOperatorExpression operator ~() {
    return MeiliNotOperatorExpression(this);
  }
}

/// Represents a value in a filter expression
abstract class MeiliValueExpressionBase extends MeiliExpressionBase {
  const MeiliValueExpressionBase();
}

/// Represents an empty filter
///
/// works as a starting point for filter builders
class MeiliEmptyExpression extends MeiliOperatorExpressionBase {
  const MeiliEmptyExpression();
  @override
  String transform() => "";
}

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
