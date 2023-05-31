import 'package:meilisearch/meilisearch.dart';
import '../annotations.dart';
import 'queryable.dart';

class DeleteDocumentsQuery extends Queryable {
  final List<Object>? ids;

  @RequiredMeiliServerVersion('1.2.0')
  final Object? filter;

  @RequiredMeiliServerVersion('1.2.0')
  final MeiliOperatorExpressionBase? filterExpression;

  bool get containsFilter => filter != null || filterExpression != null;

  const DeleteDocumentsQuery({
    this.ids,
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
