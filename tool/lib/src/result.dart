/// Possible outcomes of a command run for a package.
enum RunState {
  /// The command succeeded for the package.
  succeeded,

  /// The command failed for the package.
  failed,
}

/// The result of a [runForPackage] call.
class PackageResult {
  /// A successful result.
  PackageResult.success() : this._(RunState.succeeded);

  /// A run that failed.
  ///
  /// If [errors] are provided, they will be listed in the summary, otherwise
  /// the summary will simply show that the package failed.
  PackageResult.fail([List<String> errors = const <String>[]])
      : this._(RunState.failed, errors);

  const PackageResult._(this.state, [this.details = const <String>[]]);

  /// The state the package run completed with.
  final RunState state;

  /// Information about the result:
  /// - For `succeeded`, this is empty.
  /// - For `skipped`, it contains a single entry describing why the run was
  ///   skipped.
  /// - For `failed`, it contains zero or more specific error details to be
  ///   shown in the summary.
  final List<String> details;
}
