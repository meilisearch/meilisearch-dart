class SwapIndex {
  final List<String> indexes;

  SwapIndex(this.indexes)
      : assert(
          indexes.isEmpty || indexes.length == 2,
          'Indexes must be either empty or have exactly 2 items',
        );

  Map<String, Object> toQuery() {
    return {'indexes': indexes};
  }
}
