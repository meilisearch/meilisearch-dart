import 'package:meilisearch/meilisearch.dart';

import '../annotations.dart';
import 'queryable.dart';

class ExportQuery extends Queryable {
  final String url;
  final String? apiKey;
  final String payloadSize;
  final Map<String, ExportIndexOptions>? indexes;

  const ExportQuery({
    required this.url,
    this.apiKey,
    this.payloadSize = "50 MiB",
    this.indexes,
  });
  @override
  Map<String, Object?> buildMap() {
    return {
      'url': url,
      'apiKey': apiKey,
      'payloadSize': payloadSize,
      'indexes': indexes?.map((key, value) => MapEntry(key, value.asMap())),
    };
  }
}

class ExportIndexOptions {
  @RequiredMeiliServerVersion('1.2.0')
  final Object? filter;

  @RequiredMeiliServerVersion('1.2.0')
  final MeiliOperatorExpressionBase? filterExpression;

  final bool overrideSettings;

  bool get containsFilter => filter != null || filterExpression != null;
  const ExportIndexOptions({
    this.filter,
    this.filterExpression,
    this.overrideSettings = false,
  });

  Map<String, Object?> asMap() {
    return {
      'filter': filter ?? filterExpression?.transform(),
      'overrideSettings': overrideSettings,
    };
  }
}
