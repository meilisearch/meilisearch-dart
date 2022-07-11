class IndexesQuery {
  final int? offset;
  final int? limit;

  IndexesQuery({
    this.limit,
    this.offset,
  });

  Map<String, dynamic> toQuery() {
    return <String, dynamic>{
      'offset': this.offset,
      'limit': this.limit,
    }..removeWhere((key, value) => value == null);
  }
}
