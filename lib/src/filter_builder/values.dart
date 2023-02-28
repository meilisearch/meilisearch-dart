import 'filter_builder_base.dart';

class MeiliNumberValueExpression extends MeiliValueExpressionBase {
  final num value;

  const MeiliNumberValueExpression(this.value);

  @override
  String transform() {
    //TODO(ahmednfwela): what is the proper way to handle decimals ?
    return value.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliNumberValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class MeiliDateTimeValueExpression extends MeiliValueExpressionBase {
  final DateTime value;
  MeiliDateTimeValueExpression(this.value)
      : assert(value.isUtc, "DateTime passed to Meili must be in UTC to avoid inconsistency accross multiple devices");

  @override
  String transform() => value.millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliDateTimeValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class MeiliBooleanValueExpression extends MeiliValueExpressionBase {
  final bool value;

  const MeiliBooleanValueExpression(this.value);

  @override
  String transform() {
    return value.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliBooleanValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class MeiliStringValueExpression extends MeiliValueExpressionBase {
  final String value;

  const MeiliStringValueExpression(this.value);
  String escapeValue(String value) {
    //TODO(ahmednfwela): write a proper escape algorithm, maybe using regex
    return value.replaceAll(r'\', r'\\').replaceAll(r"'", r"\'");
  }

  @override
  String transform() {
    final sb = StringBuffer();
    sb.write("'");
    sb.write(escapeValue(value));
    sb.write("'");
    return sb.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeiliStringValueExpression && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
