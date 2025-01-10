enum MatchingStrategy {
  all,
  last,
}

extension MatchingStrategyExtension on MatchingStrategy {
  String get name {
    switch (this) {
      case MatchingStrategy.all:
        return 'all';
      case MatchingStrategy.last:
        return 'last';
      default:
        return 'last';
    }
  }
}
