import 'filter_builder_base.dart';
import 'operators.dart';
import 'values.dart';

class Meili {
  static AttributeFilterExpression attribute(String path) =>
      AttributeFilterExpression(path);
  static AttributeFilterExpression attributeFromParts(List<String> parts) =>
      AttributeFilterExpression.fromParts(parts);

  static EqualsFilterBuilder eq(
    AttributeFilterExpression path,
    FilterExpressionValueBase value,
  ) =>
      EqualsFilterBuilder(property: path, value: value);

  static GreaterThanFilterBuilder gt(
    AttributeFilterExpression path,
    FilterExpressionValueBase value,
  ) =>
      GreaterThanFilterBuilder(property: path, value: value);

  static GreaterThanEqualsFilterBuilder gte(
    AttributeFilterExpression path,
    FilterExpressionValueBase value,
  ) =>
      GreaterThanEqualsFilterBuilder(property: path, value: value);

  static LessThanEqualsFilterBuilder lte(
    AttributeFilterExpression path,
    FilterExpressionValueBase value,
  ) =>
      LessThanEqualsFilterBuilder(property: path, value: value);

  static LessThanFilterBuilder lt(
    AttributeFilterExpression path,
    FilterExpressionValueBase value,
  ) =>
      LessThanFilterBuilder(property: path, value: value);

  static NotEqualsFilterBuilder notEq(
    AttributeFilterExpression path,
    FilterExpressionValueBase value,
  ) =>
      NotEqualsFilterBuilder(property: path, value: value);

  static ToFilterBuilder to(
    AttributeFilterExpression attribute,
    FilterExpressionValueBase min,
    FilterExpressionValueBase max,
  ) =>
      ToFilterBuilder(
        min: min,
        max: max,
        attribute: attribute,
      );

  static GeoRadiusFilterBuilder geoRadius(
    double lat,
    double lng,
    double distanceInMeters,
  ) =>
      GeoRadiusFilterBuilder(
        lat,
        lng,
        distanceInMeters,
      );

  static ExistsFilterBuilder exists(AttributeFilterExpression attribute) =>
      ExistsFilterBuilder(attribute);
  static NotFilterBuilder not(FilterExpressionOperatorBase operator) =>
      NotFilterBuilder(operator);
  static InFilterBuilder $in(AttributeFilterExpression attribute,
          List<FilterExpressionValueBase> values) =>
      InFilterBuilder(
        attribute: attribute,
        values: values,
      );

  static FilterExpressionValueBase value(Object v) {
    if (v is String) {
      return StringFilterExpression(v);
    }
    if (v is num) {
      return NumberFilterExpression(v);
    }
    //Dates are converted to unix epoch time in Meili
    if (v is DateTime) {
      return NumberFilterExpression(v.millisecondsSinceEpoch);
    }
    //fall back to string value
    return StringFilterExpression(v.toString());
  }

  static OrFilterBuilder or(List<FilterExpressionOperatorBase> operands) =>
      OrFilterBuilder.fromList(operands);
  static AndFilterBuilder and(List<FilterExpressionOperatorBase> operands) =>
      AndFilterBuilder.fromList(operands);
}

extension MeiliFiltersOperatorsExt on FilterExpressionOperatorBase {
  OrFilterBuilder or(FilterExpressionOperatorBase other) =>
      OrFilterBuilder(first: this, second: other);
  OrFilterBuilder orList(List<FilterExpressionOperatorBase> others) =>
      OrFilterBuilder.fromList([this, ...others]);

  AndFilterBuilder and(FilterExpressionOperatorBase other) =>
      AndFilterBuilder(first: this, second: other);
  AndFilterBuilder andList(List<FilterExpressionOperatorBase> others) =>
      AndFilterBuilder.fromList([this, ...others]);

  NotFilterBuilder not() => NotFilterBuilder(this);
}

extension MeiliAttributesExt on AttributeFilterExpression {
  EqualsFilterBuilder eq(FilterExpressionValueBase value) =>
      Meili.eq(this, value);
  NotEqualsFilterBuilder notEq(FilterExpressionValueBase value) =>
      Meili.notEq(this, value);
  GreaterThanFilterBuilder gt(FilterExpressionValueBase value) =>
      Meili.gt(this, value);
  GreaterThanEqualsFilterBuilder gte(FilterExpressionValueBase value) =>
      Meili.gte(this, value);
  LessThanFilterBuilder lt(FilterExpressionValueBase value) =>
      Meili.lt(this, value);
  LessThanEqualsFilterBuilder lte(FilterExpressionValueBase value) =>
      Meili.lte(this, value);
  ToFilterBuilder to(
          FilterExpressionValueBase min, FilterExpressionValueBase max) =>
      Meili.to(this, min, max);
  ExistsFilterBuilder exists() => Meili.exists(this);
  InFilterBuilder $in(List<FilterExpressionValueBase> values) =>
      Meili.$in(this, values);
}

extension StrMeiliValueExt on String {
  StringFilterExpression toMeiliValue() => StringFilterExpression(this);
  AttributeFilterExpression toMeiliAttribute() =>
      AttributeFilterExpression(this);
}

extension NumMeiliValueExt on num {
  NumberFilterExpression toMeiliValue() => NumberFilterExpression(this);
}

extension DateMeiliValueExt on DateTime {
  NumberFilterExpression toMeiliValue() =>
      NumberFilterExpression(millisecondsSinceEpoch);
}
