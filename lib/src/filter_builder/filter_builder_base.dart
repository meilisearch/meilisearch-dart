import 'operators.dart';

/// Represents an arbitrary filter expression
abstract class MeiliExpressionBase {
  const MeiliExpressionBase();

  String transform();

  @override
  String toString() => transform();

  /// Fallback equality and hashing, override these when possible to optimize performance
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliExpressionBase && other.transform() == transform();
  }

  @override
  int get hashCode => transform().hashCode;
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
