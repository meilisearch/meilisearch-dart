const _defaultMaxTotalHits = 1000;

class PaginationSettings {
  ///Define the maximum number of documents reachable for a search request.
  ///It means that with the default value of `1000`, it is not possible to see the `1001`st result for a **search query**.
  int maxTotalHits;

  PaginationSettings({
    this.maxTotalHits = _defaultMaxTotalHits,
  });

  Map<String, dynamic> toMap() {
    return {
      'maxTotalHits': maxTotalHits,
    };
  }

  factory PaginationSettings.fromMap(Map<String, dynamic> map) {
    return PaginationSettings(
      maxTotalHits: map['maxTotalHits'] as int? ?? _defaultMaxTotalHits,
    );
  }
}
