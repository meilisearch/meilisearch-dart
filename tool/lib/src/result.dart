/// Possible outcomes of a command run for a package.
enum RunState {
  /// The command succeeded for the package.
  success,

  /// The command failed for the package.
  failure,
}

/// The result of a [runForPackage] call.
class PackageResult {
  /// A successful result.
  PackageResult.success() : this._(RunState.success, []);

  /// A run that failed.
  ///
  /// If [details] are provided, they will be listed in the summary, otherwise
  /// the summary will simply show that the package failed.
  PackageResult.failure(String detail) : this._(RunState.failure, [detail]);

  const PackageResult._(this.state, this.details);

  /// The state the package run completed with.
  final RunState state;

  /// Information about the result:
  /// - For `success`, this is empty.
  /// - For `failure`, it contains zero or more specific error details to be
  ///   shown in the summary.
  final List<String> details;
}
