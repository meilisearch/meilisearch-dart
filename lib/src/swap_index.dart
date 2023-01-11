class SwapIndex {
  final List<String> indexes;

  SwapIndex(this.indexes);

  Map<String, dynamic> toQuery() {
    return {'indexes': this.indexes};
  }
}
