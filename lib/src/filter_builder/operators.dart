import 'package:collection/collection.dart';
import 'package:meilisearch/meilisearch.dart';

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
    final listEquals = const DeepCollectionEquality().equals;

    return other is MeiliAndOperatorExpression &&
        listEquals(other.operands, operands);
  }

  @override
  int get hashCode =>
      Object.hash("AND", const DeepCollectionEquality().hash(operands));
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
    final listEquals = const DeepCollectionEquality().equals;

    return other is MeiliOrOperatorExpression &&
        listEquals(other.operands, operands);
  }

  @override
  int get hashCode =>
      Object.hash("OR", const DeepCollectionEquality().hash(operands));
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
  final double lat;
  final double lng;
  final double distanceInMeters;

  const MeiliGeoRadiusOperatorExpression(
      this.lat, this.lng, this.distanceInMeters);

  @override
  String transform() {
    return '_geoRadius($lat,$lng,$distanceInMeters)';
  }
}

//TODO(ahmednfwela): rework this class after Dart 3 lands with patterns
class MeiliGeoBoundingBoxOperatorExpression
    extends MeiliOperatorExpressionBase {
  final double lat1;
  final double lng1;
  final double lat2;
  final double lng2;

  const MeiliGeoBoundingBoxOperatorExpression(
    this.lat1,
    this.lng1,
    this.lat2,
    this.lng2,
  );

  @override
  String transform() {
    return '_geoBoundingBox([$lat1,$lng1],[$lat2,$lng2])';
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

/// TODO(ahmednfwela): waiting for Meili V1.2.0
// class MeiliNullOperatorExpression extends MeiliOperatorExpressionBase {
//   final MeiliAttributeExpression attribute;

//   const MeiliNullOperatorExpression(this.attribute);

//   @override
//   String transform() {
//     return "${attribute.transform()} NULL";
//   }
// }
// class MeiliNotNullOperatorExpression extends MeiliOperatorExpressionBase {
//   final MeiliAttributeExpression attribute;

//   const MeiliNotNullOperatorExpression(this.attribute);

//   @override
//   String transform() {
//     return "${attribute.transform()} NOT NULL";
//   }
// }

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
    required MeiliAttributeExpression property,
    required MeiliValueExpressionBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "=";
}

class MeiliNotEqualsOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliNotEqualsOperatorExpression({
    required MeiliAttributeExpression property,
    required MeiliValueExpressionBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "!=";
}

class MeiliGreaterThanOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliGreaterThanOperatorExpression({
    required MeiliAttributeExpression property,
    required MeiliValueExpressionBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = ">";
}

class MeiliGreaterThanEqualsOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliGreaterThanEqualsOperatorExpression({
    required MeiliAttributeExpression property,
    required MeiliValueExpressionBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = ">=";
}

class MeiliLessThanOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliLessThanOperatorExpression({
    required MeiliAttributeExpression property,
    required MeiliValueExpressionBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "<";
}

class MeiliLessThanEqualsOperatorExpression
    extends MeiliValueOperandOperatorExpressionBase {
  const MeiliLessThanEqualsOperatorExpression({
    required MeiliAttributeExpression property,
    required MeiliValueExpressionBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "<=";
}
