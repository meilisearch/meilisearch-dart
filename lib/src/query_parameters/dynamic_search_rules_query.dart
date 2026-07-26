/// Body for `POST /dynamic-search-rules`.
///
/// The list endpoint is a POST rather than a GET so callers can send an
/// arbitrary filter expression in the body. All fields are optional; an
/// empty body lists every rule with the server's default pagination.
class DynamicSearchRulesQuery {
  /// Zero-based offset into the rule list.
  final int? offset;

  /// Maximum number of rules to return in a single response.
  final int? limit;

  /// Optional filter expression matching the same grammar as Meilisearch's
  /// task and document filters (e.g. `active = true AND priority > 5`).
  final String? filter;

  const DynamicSearchRulesQuery({
    this.offset,
    this.limit,
    this.filter,
  });

  /// Serializes this query to the JSON body sent to
  /// `POST /dynamic-search-rules`. Nulls are omitted so callers only send
  /// what they set.
  Map<String, Object?> toBody() => <String, Object?>{
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (filter != null) 'filter': filter,
      };
}
