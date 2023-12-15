import 'package:collection/collection.dart';
import 'package:meilisearch/meilisearch.dart';

import '../annotations.dart';

const _eqUnordered = DeepCollectionEquality.unordered();

typedef MeiliPoint = ({num lat, num lng});

/// Represents an empty filter
///
/// works as a starting point for filter builders
class MeiliEmptyExpression extends MeiliOperatorExpressionBase {
  const MeiliEmptyExpression();

  @override
  String transform() => "";
}

class MeiliAndOperatorExpression extends MeiliOperatorExpressionBase {
  final List<MeiliOperatorExpressionBase> operands;

  MeiliAndOperatorExpression({
    required MeiliOperatorExpressionBase first,
    required MeiliOperatorExpressionBase second,
  }) : this.fromList([first, second]);

  const MeiliAndOperatorExpression.fromList(this.operands);

  @override
  String transform() {
    //space is mandatory
    final filteredOperands = operands
        .map((e) => e.transform())
        .where((element) => element.isNotEmpty);
    if (filteredOperands.isEmpty) {
      return '';
    } else if (filteredOperands.length == 1) {
      return filteredOperands.first;
    } else {
      return filteredOperands.map((e) => '($e)').join(" AND ");
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliAndOperatorExpression &&
        _eqUnordered.equals(other.operands, operands);
  }

  @override
  int get hashCode => Object.hash("AND", _eqUnordered.hash(operands));
}

class MeiliOrOperatorExpression extends MeiliOperatorExpressionBase {
  final List<MeiliOperatorExpressionBase> operands;

  MeiliOrOperatorExpression({
    required MeiliOperatorExpressionBase first,
    required MeiliOperatorExpressionBase second,
  }) : this.fromList([first, second]);

  const MeiliOrOperatorExpression.fromList(this.operands);

  @override
  String transform() {
    final filteredOperands = operands
        .map((e) => e.transform())
        .where((element) => element.isNotEmpty);
    if (filteredOperands.isEmpty) {
      return '';
    } else if (filteredOperands.length == 1) {
      return filteredOperands.first;
    } else {
      return filteredOperands.map((e) => '($e)').join(" OR ");
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliOrOperatorExpression &&
        _eqUnordered.equals(other.operands, operands);
  }

  @override
  int get hashCode => Object.hash("OR", _eqUnordered.hash(operands));
}

class MeiliToOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;
  final MeiliValueExpressionBase min;
  final MeiliValueExpressionBase max;

  const MeiliToOperatorExpression({
    required this.min,
    required this.max,
    required this.attribute,
  });

  @override
  String transform() {
    final attributeTransformed = attribute.transform();
    return "$attributeTransformed ${min.transform()} TO $attributeTransformed ${max.transform()}";
  }
}

class MeiliGeoRadiusOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliPoint point;
  final double distanceInMeters;

  const MeiliGeoRadiusOperatorExpression(
    this.point,
    this.distanceInMeters,
  );

  @override
  String transform() {
    return '_geoRadius(${point.lat},${point.lng},$distanceInMeters)';
  }
}

@RequiredMeiliServerVersion('1.1.0')
class MeiliGeoBoundingBoxOperatorExpression
    extends MeiliOperatorExpressionBase {
  final MeiliPoint point1;
  final MeiliPoint point2;

  const MeiliGeoBoundingBoxOperatorExpression(
    this.point1,
    this.point2,
  );

  @override
  String transform() {
    return '_geoBoundingBox([${point1.lat},${point1.lng}],[${point2.lat},${point2.lng}])';
  }
}

class MeiliExistsOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;

  const MeiliExistsOperatorExpression(this.attribute);

  @override
  String transform() {
    return "${attribute.transform()} EXISTS";
  }
}

class MeiliNotExistsOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;

  const MeiliNotExistsOperatorExpression(this.attribute);

  @override
  String transform() {
    return "${attribute.transform()} NOT EXISTS";
  }
}

@RequiredMeiliServerVersion('1.2.0')
class MeiliIsNullOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;

  const MeiliIsNullOperatorExpression(this.attribute);

  @override
  String transform() {
    return "${attribute.transform()} IS NULL";
  }
}

@RequiredMeiliServerVersion('1.2.0')
class MeiliIsNotNullOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;

  const MeiliIsNotNullOperatorExpression(this.attribute);

  @override
  String transform() {
    return "${attribute.transform()} IS NOT NULL";
  }
}

@RequiredMeiliServerVersion('1.2.0')
class MeiliIsEmptyOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;

  const MeiliIsEmptyOperatorExpression(this.attribute);

  @override
  String transform() {
    return "${attribute.transform()} IS EMPTY";
  }
}

@RequiredMeiliServerVersion('1.2.0')
class MeiliIsNotEmptyOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;

  const MeiliIsNotEmptyOperatorExpression(this.attribute);

  @override
  String transform() {
    return "${attribute.transform()} IS NOT EMPTY";
  }
}

class MeiliNotOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliOperatorExpressionBase operator;

  const MeiliNotOperatorExpression(this.operator)
      : assert(operator is! MeiliEmptyExpression,
            "Cannot negate (NOT) an empty operator");

  @override
  String transform() {
    return "NOT ${operator.transform()}";
  }
}

class MeiliInOperatorExpression extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression attribute;
  final List<MeiliValueExpressionBase> values;

  const MeiliInOperatorExpression({
    required this.attribute,
    required this.values,
  });

  @override
  String transform() {
    //TODO(ahmednfwela): escape commas in values ?
    return "${attribute.transform()} IN [${values.map((e) => e.transform()).join(',')}]";
  }
}

/// Represents an operator that has a value as an operand
abstract class MeiliValueOperandOperatorExpressionBase
    extends MeiliOperatorExpressionBase {
  final MeiliAttributeExpression property;
  final MeiliValueExpressionBase value;

  const MeiliValueOperandOperatorExpressionBase({
    required this.property,
    required this.value,
  });

  String get operator;

  @override
  String transform() {
    return '${property.transform()} $operator ${value.transform()}';
  }
}

class MeiliEqualsOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliEqualsOperatorExpression({
    required super.property,
    required super.value,
  });

  @override
  final String operator = "=";
}

class MeiliNotEqualsOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliNotEqualsOperatorExpression({
    required super.property,
    required super.value,
  });

  @override
  final String operator = "!=";
}

class MeiliGreaterThanOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliGreaterThanOperatorExpression({
    required super.property,
    required super.value,
  });

  @override
  final String operator = ">";
}

class MeiliGreaterThanEqualsOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliGreaterThanEqualsOperatorExpression({
    required super.property,
    required super.value,
  });

  @override
  final String operator = ">=";
}

class MeiliLessThanOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliLessThanOperatorExpression({
    required super.property,
    required super.value,
  });

  @override
  final String operator = "<";
}

class MeiliLessThanEqualsOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliLessThanEqualsOperatorExpression({
    required super.property,
    required super.value,
  });

  @override
  final String operator = "<=";
}
