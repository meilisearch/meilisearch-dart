class Meili {
  static PropertyPathFilterExpression path(String path) => PropertyPathFilterExpression(path);
  static PropertyPathFilterExpression pathFromParts(List<String> parts) => PropertyPathFilterExpression.fromParts(parts);

  static FilterExpressionOperatorBase eq(PropertyPathFilterExpression path, FilterExpressionValueBase value) =>
      EqualsFilterBuilder(property: path, value: value);

  static FilterExpressionValueBase value(Object? v) {
    if (v == null) {
      return const NullFilterExpression();
    }
    if (v is String) {
      return StringFilterExpression(v);
    }
    if (v is num) {
      return NumberFilterExpression(v);
    }
    //fall back to string value
    return StringFilterExpression(v.toString());
  }

  static FilterExpressionOperatorBase or(List<FilterExpressionBase> operands) => OrFilterBuilder.fromList(operands);
  static FilterExpressionOperatorBase and(List<FilterExpressionBase> operands) => AndFilterBuilder.fromList(operands);
}

extension MeiliFiltersExt on FilterExpressionBase {
  FilterExpressionOperatorBase or(FilterExpressionBase other) => OrFilterBuilder(first: this, second: other);
  FilterExpressionOperatorBase orList(List<FilterExpressionBase> others) => OrFilterBuilder.fromList([this, ...others]);

  FilterExpressionOperatorBase and(FilterExpressionBase other) => AndFilterBuilder(first: this, second: other);
  FilterExpressionOperatorBase andList(List<FilterExpressionBase> others) => AndFilterBuilder.fromList([this, ...others]);
}

abstract class FilterExpressionBase {
  const FilterExpressionBase();
  String transform();
  @override
  String toString() => transform();
}

abstract class FilterExpressionOperatorBase extends FilterExpressionBase {
  const FilterExpressionOperatorBase();
}

abstract class FilterExpressionValueBase extends FilterExpressionBase {
  const FilterExpressionValueBase();
}

class PropertyPathFilterExpression extends FilterExpressionBase {
  final String path;
  final List<String> parts;

  PropertyPathFilterExpression(this.path) : parts = path.split('.');
  PropertyPathFilterExpression.fromParts(this.parts) : path = parts.join('.');

  @override
  String transform() {
    return path;
  }
}

class NullFilterExpression extends FilterExpressionValueBase {
  const NullFilterExpression();

  @override
  String transform() {
    return "null";
  }
}

class NumberFilterExpression extends FilterExpressionValueBase {
  final num value;

  const NumberFilterExpression(this.value);

  @override
  String transform() {
    //TODO(ahmednfwela): what is the proper way to handle decimals ?
    return value.toString();
  }
}

class StringFilterExpression extends FilterExpressionValueBase {
  final String value;

  const StringFilterExpression(this.value);
  String escapeValue(String value) {
    //TODO(ahmednfwela): write a proper escape algorithm, maybe using regex
    return value;
  }

  @override
  String transform() {
    final sb = StringBuffer();
    sb.write("'");
    sb.write(escapeValue(value));
    sb.write("'");
    return sb.toString();
  }
}

class AndFilterBuilder extends FilterExpressionOperatorBase {
  final List<FilterExpressionBase> operands;

  AndFilterBuilder({
    required FilterExpressionBase first,
    required FilterExpressionBase second,
  }) : this.fromList([first, second]);

  const AndFilterBuilder.fromList(this.operands);

  @override
  String transform() {
    //space is mandatory
    return operands.map((e) => e.transform()).map((e) => '($e)').join(" And ");
  }
}

class OrFilterBuilder extends FilterExpressionOperatorBase {
  final List<FilterExpressionBase> operands;

  OrFilterBuilder({
    required FilterExpressionBase first,
    required FilterExpressionBase second,
  }) : this.fromList([first, second]);

  const OrFilterBuilder.fromList(this.operands);

  @override
  String transform() {
    return operands.map((e) => e.transform()).map((e) => '($e)').join(" OR ");
  }
}

class EqualsFilterBuilder extends FilterExpressionOperatorBase {
  final PropertyPathFilterExpression property;
  final FilterExpressionValueBase value;

  const EqualsFilterBuilder({
    required this.property,
    required this.value,
  });

  @override
  String transform() {
    return '${property.transform()} = (${value.transform()})';
  }
}
