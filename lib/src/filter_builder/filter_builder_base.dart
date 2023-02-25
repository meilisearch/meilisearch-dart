import 'operators.dart';

/// Represents an arbitrary filter expression
abstract class FilterExpressionBase {
  const FilterExpressionBase();
  String transform();
  @override
  String toString() => transform();
}

/// Represents a filter operator with either at least one operand
abstract class FilterExpressionOperatorBase extends FilterExpressionBase {
  const FilterExpressionOperatorBase();

  AndFilterBuilder operator &(FilterExpressionOperatorBase other) {
    return AndFilterBuilder(first: this, second: other);
  }

  OrFilterBuilder operator |(FilterExpressionOperatorBase other) {
    return OrFilterBuilder(first: this, second: other);
  }

  NotFilterBuilder operator ~() {
    return NotFilterBuilder(this);
  }
}

/// Represents a value in a filter expression
abstract class FilterExpressionValueBase extends FilterExpressionBase {
  const FilterExpressionValueBase();
}

/// Represents an empty filter
class EmptyFilterExpression extends FilterExpressionOperatorBase {
  const EmptyFilterExpression();
  @override
  String transform() => "";
}

/// Represents an attribute path in a filter expression
class AttributeFilterExpression extends FilterExpressionBase {
  final List<String> parts;

  AttributeFilterExpression(String path)
      : parts = _normalizeParts(path.split('.'));
  AttributeFilterExpression.fromParts(List<String> parts)
      : parts = _normalizeParts(parts);
  static List<String> _normalizeParts(List<String> parts) {
    return parts
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  @override
  String transform() {
    return parts.join('.');
  }

  LessThanFilterBuilder operator <(FilterExpressionValueBase value) {
    return LessThanFilterBuilder(property: this, value: value);
  }

  GreaterThanFilterBuilder operator >(FilterExpressionValueBase value) {
    return GreaterThanFilterBuilder(property: this, value: value);
  }

  GreaterThanEqualsFilterBuilder operator >=(FilterExpressionValueBase value) {
    return GreaterThanEqualsFilterBuilder(property: this, value: value);
  }

  LessThanEqualsFilterBuilder operator <=(FilterExpressionValueBase value) {
    return LessThanEqualsFilterBuilder(property: this, value: value);
  }
}
