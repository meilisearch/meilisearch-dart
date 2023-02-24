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
}

/// Represents a value in a filter expression
abstract class FilterExpressionValueBase extends FilterExpressionBase {
  const FilterExpressionValueBase();
}

/// Represents an attribute path in a filter expression
class AttributeFilterExpression extends FilterExpressionBase {
  final String path;
  final List<String> parts;

  AttributeFilterExpression(this.path) : parts = path.split('.');
  AttributeFilterExpression.fromParts(this.parts) : path = parts.join('.');

  @override
  String transform() {
    return path;
  }
}
