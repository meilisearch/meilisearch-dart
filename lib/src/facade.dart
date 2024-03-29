import 'annotations.dart';
import 'filter_builder/_exports.dart';

/// Convenience class to access all Meilisearch filter expressions

class Meili {
  Meili._();

  /// Creates an attribute from string
  static MeiliAttributeExpression attr(String path) =>
      MeiliAttributeExpression(path);

  /// Creates an attribute from parts to represent object nesting
  ///
  /// `Meili.attrFromParts(['contact','phone'])` is equivalent to `Meili.attr('contact.phone')`
  static MeiliAttributeExpression attrFromParts(List<String> parts) =>
      MeiliAttributeExpression.fromParts(parts);

  /// Creates an `ATTR = VALUE` filter operator
  static MeiliEqualsOperatorExpression eq(
    MeiliAttributeExpression path,
    MeiliValueExpressionBase value,
  ) =>
      MeiliEqualsOperatorExpression(property: path, value: value);

  static MeiliGreaterThanOperatorExpression gt(
    MeiliAttributeExpression path,
    MeiliValueExpressionBase value,
  ) =>
      MeiliGreaterThanOperatorExpression(property: path, value: value);

  static MeiliGreaterThanEqualsOperatorExpression gte(
    MeiliAttributeExpression path,
    MeiliValueExpressionBase value,
  ) =>
      MeiliGreaterThanEqualsOperatorExpression(property: path, value: value);

  static MeiliLessThanEqualsOperatorExpression lte(
    MeiliAttributeExpression path,
    MeiliValueExpressionBase value,
  ) =>
      MeiliLessThanEqualsOperatorExpression(property: path, value: value);

  static MeiliLessThanOperatorExpression lt(
    MeiliAttributeExpression path,
    MeiliValueExpressionBase value,
  ) =>
      MeiliLessThanOperatorExpression(property: path, value: value);

  static MeiliNotEqualsOperatorExpression notEq(
    MeiliAttributeExpression path,
    MeiliValueExpressionBase value,
  ) =>
      MeiliNotEqualsOperatorExpression(property: path, value: value);

  static MeiliToOperatorExpression to(
    MeiliAttributeExpression attribute,
    MeiliValueExpressionBase min,
    MeiliValueExpressionBase max,
  ) =>
      MeiliToOperatorExpression(
        min: min,
        max: max,
        attribute: attribute,
      );

  static MeiliGeoRadiusOperatorExpression geoRadius(
    MeiliPoint point,
    double distanceInMeters,
  ) =>
      MeiliGeoRadiusOperatorExpression(
        (lat: point.lat, lng: point.lng),
        distanceInMeters,
      );

  @RequiredMeiliServerVersion('1.1.0')
  static MeiliGeoBoundingBoxOperatorExpression geoBoundingBox(
    MeiliPoint p1,
    MeiliPoint p2,
  ) =>
      MeiliGeoBoundingBoxOperatorExpression(p1, p2);

  static MeiliExistsOperatorExpression exists(
          MeiliAttributeExpression attribute) =>
      MeiliExistsOperatorExpression(attribute);
  static MeiliNotExistsOperatorExpression notExists(
          MeiliAttributeExpression attribute) =>
      MeiliNotExistsOperatorExpression(attribute);

  @RequiredMeiliServerVersion('1.2.0')
  static MeiliIsNullOperatorExpression isNull(
    MeiliAttributeExpression attribute,
  ) =>
      MeiliIsNullOperatorExpression(attribute);

  @RequiredMeiliServerVersion('1.2.0')
  static MeiliIsNotNullOperatorExpression isNotNull(
    MeiliAttributeExpression attribute,
  ) =>
      MeiliIsNotNullOperatorExpression(attribute);

  @RequiredMeiliServerVersion('1.2.0')
  static MeiliIsEmptyOperatorExpression isEmpty(
    MeiliAttributeExpression attribute,
  ) =>
      MeiliIsEmptyOperatorExpression(attribute);

  @RequiredMeiliServerVersion('1.2.0')
  static MeiliIsNotEmptyOperatorExpression isNotEmpty(
    MeiliAttributeExpression attribute,
  ) =>
      MeiliIsNotEmptyOperatorExpression(attribute);

  static MeiliNotOperatorExpression not(MeiliOperatorExpressionBase operator) =>
      MeiliNotOperatorExpression(operator);
  static MeiliInOperatorExpression $in(MeiliAttributeExpression attribute,
          List<MeiliValueExpressionBase> values) =>
      MeiliInOperatorExpression(
        attribute: attribute,
        values: values,
      );

  static List<MeiliValueExpressionBase> values(Iterable<Object> v) {
    return v.map(value).toList();
  }

  static MeiliValueExpressionBase value(Object v) {
    if (v is String) {
      return MeiliStringValueExpression(v);
    }
    if (v is num) {
      return MeiliNumberValueExpression(v);
    }
    if (v is bool) {
      return MeiliBooleanValueExpression(v);
    }
    if (v is DateTime) {
      return MeiliDateTimeValueExpression(v);
    }
    // fallback to a string value
    return MeiliStringValueExpression(v.toString());
  }

  static MeiliOrOperatorExpression or(
    List<MeiliOperatorExpressionBase> operands,
  ) =>
      MeiliOrOperatorExpression.fromList(operands);

  static MeiliAndOperatorExpression and(
    List<MeiliOperatorExpressionBase> operands,
  ) =>
      MeiliAndOperatorExpression.fromList(operands);

  static MeiliEmptyExpression empty() => MeiliEmptyExpression();
}

extension MeiliFiltersOperatorsExt on MeiliOperatorExpressionBase {
  MeiliOrOperatorExpression or(MeiliOperatorExpressionBase other) =>
      MeiliOrOperatorExpression(first: this, second: other);
  MeiliOrOperatorExpression orList(List<MeiliOperatorExpressionBase> others) =>
      MeiliOrOperatorExpression.fromList([this, ...others]);

  MeiliAndOperatorExpression and(MeiliOperatorExpressionBase other) =>
      MeiliAndOperatorExpression(first: this, second: other);
  MeiliAndOperatorExpression andList(
          List<MeiliOperatorExpressionBase> others) =>
      MeiliAndOperatorExpression.fromList([this, ...others]);

  MeiliNotOperatorExpression not() => MeiliNotOperatorExpression(this);
}

extension MeiliAttributesExt on MeiliAttributeExpression {
  MeiliEqualsOperatorExpression eq(MeiliValueExpressionBase value) =>
      Meili.eq(this, value);

  MeiliNotEqualsOperatorExpression notEq(MeiliValueExpressionBase value) =>
      Meili.notEq(this, value);

  MeiliGreaterThanOperatorExpression gt(MeiliValueExpressionBase value) =>
      Meili.gt(this, value);

  MeiliGreaterThanEqualsOperatorExpression gte(
    MeiliValueExpressionBase value,
  ) =>
      Meili.gte(this, value);

  MeiliLessThanOperatorExpression lt(MeiliValueExpressionBase value) =>
      Meili.lt(this, value);

  MeiliLessThanEqualsOperatorExpression lte(MeiliValueExpressionBase value) =>
      Meili.lte(this, value);

  MeiliToOperatorExpression to(
    MeiliValueExpressionBase min,
    MeiliValueExpressionBase max,
  ) =>
      Meili.to(this, min, max);

  MeiliExistsOperatorExpression exists() => Meili.exists(this);

  MeiliNotExistsOperatorExpression notExists() => Meili.notExists(this);

  @RequiredMeiliServerVersion('1.2.0')
  MeiliIsNullOperatorExpression isNull() => Meili.isNull(this);

  @RequiredMeiliServerVersion('1.2.0')
  MeiliIsNotNullOperatorExpression isNotNull() => Meili.isNotNull(this);

  @RequiredMeiliServerVersion('1.2.0')
  MeiliIsEmptyOperatorExpression isEmpty() => Meili.isEmpty(this);

  @RequiredMeiliServerVersion('1.2.0')
  MeiliIsNotEmptyOperatorExpression isNotEmpty() => Meili.isNotEmpty(this);

  MeiliInOperatorExpression $in(List<MeiliValueExpressionBase> values) =>
      Meili.$in(this, values);
}

extension StrMeiliValueExt on String {
  MeiliStringValueExpression toMeiliValue() => MeiliStringValueExpression(this);
  MeiliAttributeExpression toMeiliAttribute() => MeiliAttributeExpression(this);
}

extension NumMeiliValueExt on num {
  MeiliNumberValueExpression toMeiliValue() => MeiliNumberValueExpression(this);
}

extension DateMeiliValueExt on DateTime {
  MeiliDateTimeValueExpression toMeiliValue() =>
      MeiliDateTimeValueExpression(this);
}

extension BoolMeiliValueExt on bool {
  MeiliBooleanValueExpression toMeiliValue() =>
      MeiliBooleanValueExpression(this);
}
