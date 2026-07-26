/// A Dynamic Search Rule as returned by the
/// `GET /dynamic-search-rules/{uid}` and `POST /dynamic-search-rules`
/// endpoints introduced in Meilisearch v1.50.0 (experimental).
///
/// The rule shape follows the [Meilisearch reference](https://www.meilisearch.com/docs/capabilities/search_rules/overview).
/// `conditions` and `actions` are exposed as raw maps/lists so the SDK
/// keeps working when new sub-fields are added on the server side without a
/// coordinated release. Callers that want strongly typed access can wrap
/// them at their layer.
class DynamicSearchRule {
  /// The rule's unique identifier (path parameter for the single-rule
  /// endpoints).
  final String uid;

  /// Human-readable description.
  final String? description;

  /// Ordering key when several rules match a given query. In v1.50.0 this
  /// field was renamed from `priority` to `precedence`, and **lower**
  /// numeric values apply first: a rule with `precedence: 1` is picked
  /// before a rule with `precedence: 5`.
  final int? precedence;

  /// Whether the rule is currently active.
  final bool? active;

  /// Condition tree that decides when the rule fires (query patterns,
  /// time windows, etc.). Exposed as a raw map so consumers see every
  /// field the server sends, including ones added after this SDK ships.
  final Map<String, Object?>? conditions;

  /// Ordered list of actions the rule performs when it fires (typically
  /// document pinning). Same raw-map rationale as [conditions].
  final List<Map<String, Object?>>? actions;

  /// ISO-8601 timestamp; present when the server returns it.
  final DateTime? createdAt;

  /// ISO-8601 timestamp; present when the server returns it.
  final DateTime? updatedAt;

  const DynamicSearchRule({
    required this.uid,
    this.description,
    this.precedence,
    this.active,
    this.conditions,
    this.actions,
    this.createdAt,
    this.updatedAt,
  });

  factory DynamicSearchRule.fromJson(Map<String, Object?> json) {
    final actionsRaw = json['actions'];
    final createdAtRaw = json['createdAt'];
    final updatedAtRaw = json['updatedAt'];
    final conditionsRaw = json['conditions'];
    return DynamicSearchRule(
      uid: json['uid'] as String? ?? '',
      description: json['description'] as String?,
      precedence: json['precedence'] as int?,
      active: json['active'] as bool?,
      conditions: conditionsRaw is Map
          ? Map<String, Object?>.from(conditionsRaw)
          : null,
      actions: actionsRaw is Iterable
          ? actionsRaw
              .whereType<Map<Object?, Object?>>()
              .map(Map<String, Object?>.from)
              .toList()
          : null,
      createdAt:
          createdAtRaw is String ? DateTime.tryParse(createdAtRaw) : null,
      updatedAt:
          updatedAtRaw is String ? DateTime.tryParse(updatedAtRaw) : null,
    );
  }

  /// Body used when upserting a rule via
  /// `PATCH /dynamic-search-rules/{uid}`. Fields that are null on this
  /// instance are omitted so callers can send sparse updates.
  Map<String, Object?> toUpsertBody() => <String, Object?>{
        if (description != null) 'description': description,
        if (precedence != null) 'precedence': precedence,
        if (active != null) 'active': active,
        if (conditions != null) 'conditions': conditions,
        if (actions != null) 'actions': actions,
      };
}
