import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:meili_tool/src/result.dart';
import 'package:platform/platform.dart';
import 'package:path/path.dart' as p;

abstract class MeiliCommandBase extends Command<PackageResult> {
  final Directory packageDirectory;

  MeiliCommandBase(
    this.packageDirectory, {
    this.platform = const LocalPlatform(),
  });

  /// The current platform.
  ///
  /// This can be overridden for testing.
  final Platform platform;

  /// A context that matches the default for [platform].
  p.Context get path => platform.isWindows ? p.windows : p.posix;
  // Returns the relative path from [from] to [entity] in Posix style.
  ///
  /// This should be used when, for example, printing package-relative paths in
  /// status or error messages.
  String getRelativePosixPath(
    FileSystemEntity entity, {
    required Directory from,
  }) =>
      p.posix.joinAll(path.split(path.relative(entity.path, from: from.path)));

  String get indentation => '  ';

  bool getBoolArg(String key) {
    return (argResults![key] as bool?) ?? false;
  }
}
