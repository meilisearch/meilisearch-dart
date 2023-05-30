import 'package:meilisearch/meilisearch.dart';
import '../annotations.dart';
import 'queryable.dart';

@MeiliServerVersion('1.2.0')
class DeleteDocumentsQuery extends Queryable {
  final Object? filter;
  final MeiliOperatorExpressionBase? filterExpression;

  const DeleteDocumentsQuery({
    this.filter,
    this.filterExpression,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'filter': filter ?? filterExpression?.transform(),
    };
  }
}
