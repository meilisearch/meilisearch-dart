import 'filter_builder_base.dart';

//null is not a valid value, use EXISTS operator instead
// class NullFilterExpression extends FilterExpressionValueBase {
//   const NullFilterExpression();

//   @override
//   String transform() {
//     return "null";
//   }
// }

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
