class DocumentsQuery {
  final int? offset;
  final int? limit;
  final List<String> fields;

  DocumentsQuery({this.limit, this.offset, this.fields: const []});

  Map<String, dynamic> toQuery() {
    return <String, dynamic>{
      'offset': this.offset,
      'limit': this.limit,
      if (this.fields.isNotEmpty) 'fields': fields.join(',')
    }..removeWhere((_key, value) => value == null);
  }
}
