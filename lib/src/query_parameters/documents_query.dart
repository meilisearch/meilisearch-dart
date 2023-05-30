import 'package:meilisearch/meilisearch.dart';
import 'queryable.dart';
import '../annotations.dart';

class DocumentsQuery extends Queryable {
  final int? offset;
  final int? limit;
  final List<String> fields;
  @MeiliServerVersion('1.2.0')
  final Object? filter;
  @MeiliServerVersion('1.2.0')
  final MeiliOperatorExpressionBase? filterExpression;

  const DocumentsQuery({
    this.limit,
    this.offset,
    this.fields = const [],
    this.filter,
    this.filterExpression,
  });

  @override
  Map<String, Object?> buildMap() {
    return {
      'offset': offset,
      'limit': limit,
      'fields': fields,
      'filter': filter ?? filterExpression?.transform(),
    };
  }
}
