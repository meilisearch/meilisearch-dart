import 'package:collection/collection.dart';

import 'package:meilisearch/meilisearch.dart';

class AndFilterBuilder extends FilterExpressionOperatorBase {
  final List<FilterExpressionOperatorBase> operands;

  AndFilterBuilder({
    required FilterExpressionOperatorBase first,
    required FilterExpressionOperatorBase second,
  }) : this.fromList([first, second]);

  const AndFilterBuilder.fromList(this.operands);

  @override
  String transform() {
    //space is mandatory
    return operands
        .map((e) => e.transform())
        .where((element) => element.isNotEmpty)
        .map((e) => '($e)')
        .join(" AND ");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is AndFilterBuilder && listEquals(other.operands, operands);
  }

  @override
  int get hashCode =>
      Object.hash("AND", const DeepCollectionEquality().hash(operands));
}

class ToFilterBuilder extends FilterExpressionOperatorBase {
  final AttributeFilterExpression attribute;
  final FilterExpressionValueBase min;
  final FilterExpressionValueBase max;

  const ToFilterBuilder({
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

class OrFilterBuilder extends FilterExpressionOperatorBase {
  final List<FilterExpressionOperatorBase> operands;

  OrFilterBuilder({
    required FilterExpressionOperatorBase first,
    required FilterExpressionOperatorBase second,
  }) : this.fromList([first, second]);

  const OrFilterBuilder.fromList(this.operands);

  @override
  String transform() {
    return operands
        .map((e) => e.transform())
        .where((element) => element.isNotEmpty)
        .map((e) => '($e)')
        .join(" OR ");
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is OrFilterBuilder && listEquals(other.operands, operands);
  }

  @override
  int get hashCode =>
      Object.hash("OR", const DeepCollectionEquality().hash(operands));
}

class GeoRadiusFilterBuilder extends FilterExpressionOperatorBase {
  final double lat;
  final double lng;
  final double distanceInMeters;

  const GeoRadiusFilterBuilder(this.lat, this.lng, this.distanceInMeters);

  @override
  String transform() {
    return '_geoRadius($lat,$lng,$distanceInMeters)';
  }
}

class ExistsFilterBuilder extends FilterExpressionOperatorBase {
  final AttributeFilterExpression attribute;

  const ExistsFilterBuilder(this.attribute);

  @override
  String transform() {
    return "${attribute.transform()} EXISTS";
  }
}

class NotFilterBuilder extends FilterExpressionOperatorBase {
  final FilterExpressionOperatorBase operator;

  const NotFilterBuilder(this.operator)
      : assert(operator is! EmptyFilterExpression,
            "Cannot negate (NOT) an empty operator");

  @override
  String transform() {
    return "NOT ${operator.transform()}";
  }
}

class InFilterBuilder extends FilterExpressionOperatorBase {
  final AttributeFilterExpression attribute;
  final List<FilterExpressionValueBase> values;

  const InFilterBuilder({
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
abstract class ValueOperandFilterBuilder extends FilterExpressionOperatorBase {
  final AttributeFilterExpression property;
  final FilterExpressionValueBase value;

  const ValueOperandFilterBuilder({
    required this.property,
    required this.value,
  });

  String get operator;

  @override
  String transform() {
    return '${property.transform()} $operator ${value.transform()}';
  }
}

class EqualsFilterBuilder extends ValueOperandFilterBuilder {
  const EqualsFilterBuilder({
    required AttributeFilterExpression property,
    required FilterExpressionValueBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "=";
}

class NotEqualsFilterBuilder extends ValueOperandFilterBuilder {
  const NotEqualsFilterBuilder({
    required AttributeFilterExpression property,
    required FilterExpressionValueBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "!=";
}

class GreaterThanFilterBuilder extends ValueOperandFilterBuilder {
  const GreaterThanFilterBuilder({
    required AttributeFilterExpression property,
    required FilterExpressionValueBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = ">";
}

class GreaterThanEqualsFilterBuilder extends ValueOperandFilterBuilder {
  const GreaterThanEqualsFilterBuilder({
    required AttributeFilterExpression property,
    required FilterExpressionValueBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = ">=";
}

class LessThanFilterBuilder extends ValueOperandFilterBuilder {
  const LessThanFilterBuilder({
    required AttributeFilterExpression property,
    required FilterExpressionValueBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "<";
}

class LessThanEqualsFilterBuilder extends ValueOperandFilterBuilder {
  const LessThanEqualsFilterBuilder({
    required AttributeFilterExpression property,
    required FilterExpressionValueBase value,
  }) : super(property: property, value: value);

  @override
  final String operator = "<=";
}
