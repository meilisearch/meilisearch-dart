/// The filter object accepted inside a
/// `POST /dynamic-search-rules` body (Meilisearch v1.50.0+).
///
/// In v1.50.0 the list-endpoint filter changed shape: instead of a bare
/// filter-expression string it takes an object. [query] searches across
/// the rule's description and its `conditions.query.words`; [active]
/// narrows the result to active/paused rules.
class DynamicSearchRulesFilter {
  final String? query;
  final bool? active;

  const DynamicSearchRulesFilter({this.query, this.active});

  Map<String, Object?> toJson() => <String, Object?>{
        if (query != null) 'query': query,
        if (active != null) 'active': active,
      };
}

/// Body for `POST /dynamic-search-rules`.
///
/// The list endpoint is a POST rather than a GET so callers can send an
/// arbitrary filter object in the body. All fields are optional; an
/// empty body lists every rule with the server's default pagination.
class DynamicSearchRulesQuery {
  /// Zero-based offset into the rule list.
  final int? offset;

  /// Maximum number of rules to return in a single response.
  final int? limit;

  /// Optional filter object. See [DynamicSearchRulesFilter].
  final DynamicSearchRulesFilter? filter;

  const DynamicSearchRulesQuery({
    this.offset,
    this.limit,
    this.filter,
  });

  /// Serializes this query to the JSON body sent to
  /// `POST /dynamic-search-rules`. Nulls are omitted so callers only send
  /// what they set. An empty filter object is also omitted so an
  /// unconfigured [filter] doesn't send `{}` on the wire.
  Map<String, Object?> toBody() {
    final filterMap = filter?.toJson();
    return <String, Object?>{
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
      if (filterMap != null && filterMap.isNotEmpty) 'filter': filterMap,
    };
  }
}
