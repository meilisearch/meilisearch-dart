import 'package:meilisearch/meilisearch.dart';
import 'queryable.dart';
import '../annotations.dart';

class DocumentsQuery extends Queryable {
  final int? offset;
  final int? limit;
  final List<String> fields;

  @RequiredMeiliServerVersion('1.14.0')
  final List<Object> ids;

  @RequiredMeiliServerVersion('1.2.0')
  final Object? filter;

  @RequiredMeiliServerVersion('1.2.0')
  final MeiliOperatorExpressionBase? filterExpression;

  bool get containsFilter => filter != null || filterExpression != null;

  const DocumentsQuery({
    this.limit,
    this.offset,
    this.fields = const [],
    this.ids = const [],
    this.filter,
    this.filterExpression,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'offset': offset,
      'limit': limit,
      'fields': fields,
      'ids': ids,
      'filter': filter ?? filterExpression?.transform(),
    };
  }
}
