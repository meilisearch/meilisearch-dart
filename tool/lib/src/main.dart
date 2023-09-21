import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:meili_tool/src/output_utils.dart';
import 'package:meili_tool/src/result.dart';

import 'core.dart';
import 'update_samples_command.dart';

void main(List<String> arguments) {
  const FileSystem fileSystem = LocalFileSystem();
  final Directory scriptDir =
      fileSystem.file(io.Platform.script.toFilePath()).parent;
  final Directory toolsDir =
      scriptDir.basename == 'bin' ? scriptDir.parent : scriptDir.parent.parent;

  final Directory meilisearchDirectory = toolsDir.parent;

  final commandRunner = CommandRunner<PackageResult>(
      'dart run ./tool/bin/meili.dart', 'Productivity utils for meilisearch.')
    ..addCommand(UpdateSamplesCommand(meilisearchDirectory));

  commandRunner.run(arguments).then((value) {
    if (value == null) {
      print('MUST output either a success or fail.');
      assert(false);
      io.exit(255);
    }
    switch (value.state) {
      case RunState.succeeded:
        printSuccess('Success!');
        break;
      case RunState.failed:
        printError('Failed!');
        if (value.details.isNotEmpty) {
          printError(value.details.join('\n'));
        }
    }
  }).catchError((Object e) {
    final ToolExit toolExit = e as ToolExit;
    int exitCode = toolExit.exitCode;
    // This should never happen; this check is here to guarantee that a ToolExit
    // never accidentally has code 0 thus causing CI to pass.
    if (exitCode == 0) {
      assert(false);
      exitCode = 255;
    }
    io.exit(exitCode);
  }, test: (Object e) => e is ToolExit);
}
