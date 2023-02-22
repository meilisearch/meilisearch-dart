class SwapIndex {
  final List<String> indexes;

  SwapIndex(this.indexes);

  Map<String, Object> toQuery() {
    return {'indexes': this.indexes};
  }
}
